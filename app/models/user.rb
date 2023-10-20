# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  admin                           :boolean          default(FALSE), not null
#  display_name                    :string
#  email                           :citext
#  email_verification_token        :string
#  email_verified_at               :datetime
#  last_login_at                   :datetime
#  new_email                       :citext
#  password_changed_at             :datetime         not null
#  password_digest                 :string
#  preferences                     :jsonb            not null
#  reset_password_token            :string
#  reset_password_token_created_at :datetime
#  username                        :string           not null
#  verification_email_sent_at      :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email                     (email) UNIQUE WHERE (email IS NOT NULL)
#  index_users_on_email_verification_token  (email_verification_token) UNIQUE WHERE (email_verification_token IS NOT NULL)
#  index_users_on_new_email                 (new_email) UNIQUE WHERE (new_email IS NOT NULL)
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE WHERE (reset_password_token IS NOT NULL)
#  index_users_on_username                  (username) UNIQUE
#
class User < ApplicationRecord
  include ResetPasswordToken
  include EmailVerification

  has_one :log,
          foreign_key: :user_id,
          inverse_of: :user,
          dependent: :destroy

  has_many :group_memberships, dependent: :destroy

  # has_paper_trail
  has_secure_password

  normalizes :display_name, with: -> display_name { display_name.squish.presence }
  normalizes :email, with: -> email { email.strip.presence }
  normalizes :new_email, with: -> new_email { new_email.strip.presence }

  before_validation do
    # email is always copied to username and downcased currently
    self.username = email&.downcase
  end

  before_save do
    self.password_changed_at = Time.current.utc if will_save_change_to_password_digest?
  end

  validates :username, presence: true, uniqueness: true, format: /\A\S+\z/
  # Duplicated in UserSignup:
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 255 },
            format: /\A\S.*\S\z/,
            if: -> { !password.nil? }
  validates :display_name, presence: true, uniqueness: true
  validates :email,
            presence: true,
            length: { maximum: 255 },
            uniqueness: true
  validates :new_email,
            format: { with: /\A\S[^@]*@[^@]*\S\z/, allow_nil: true },
            length: { maximum: 255, allow_nil: true }
  validate :new_email_must_be_unique

  scope :by_name, -> { order(:display_name) }

  # Perform a case-insensitive username lookup (username is always lower-case email)
  scope :with_username, -> (username) { where(username: username.to_s.downcase) }
  scope :with_email_or_new_email, -> (email) {
    where(email: email).or(where(new_email: email))
  }

  def user_group_ids
    # association is expected to be re-used in the request after lazy load
    group_memberships.map(&:user_group_id)
  end

  # Username without email suffix "@domain"
  def short_username
    username.split('@', 2).first if username
  end

  private

    def new_email_must_be_unique
      if new_email.present? && new_email_changed?
        relation = self.class.with_email_or_new_email(new_email)
        if persisted?
          relation = relation.where.not(id: self.id)
        end
        if relation.exists?
          errors.add(:new_email, "is already taken")
        end
      end
    end
end

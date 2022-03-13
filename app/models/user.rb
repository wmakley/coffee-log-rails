# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  admin                           :boolean          default(FALSE), not null
#  display_name                    :string
#  email                           :citext
#  password_changed_at             :datetime         not null
#  password_digest                 :string
#  preferences                     :jsonb            not null
#  reset_password_token            :string
#  reset_password_token_created_at :datetime
#  username                        :string           not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE WHERE (email IS NOT NULL)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE WHERE (reset_password_token IS NOT NULL)
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  include ResetPasswordToken

  has_one :log,
          foreign_key: :user_id,
          inverse_of: :user,
          dependent: :destroy

  has_paper_trail
  has_secure_password

  before_validation do
    self.display_name = display_name&.squish.presence
    self.email = email&.strip.presence
  end

  before_save do
    self.password_changed_at = Time.current.utc if will_save_change_to_password_digest?
    self.email = email&.presence&.downcase
  end

  validates :username, presence: true, uniqueness: true, format: /\A\S+\z/
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 255 },
            format: /\A\S.*\S\z/,
            if: -> { !password.nil? }
  validates :display_name, presence: true, uniqueness: true
  validates :email,
            presence: true,
            length: { maximum: 255, allow_nil: true },
            uniqueness: true

  scope :by_name, -> { order(:display_name) }
end

# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_logs_on_slug     (slug) UNIQUE
#  index_logs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Log < ApplicationRecord
  has_many :log_entries, inverse_of: :log, dependent: :destroy
  belongs_to :user, inverse_of: :log

  validates :title,
            presence: true,
            length: { maximum: 255 }

  validates :slug,
            presence: true,
            uniqueness: true,
            length: { maximum: 255 },
            format: /\A[a-z0-9\-_]+\z/

  before_validation do
    self.title = title&.squish
    self.slug = slug&.strip
  end

  scope :user, ->(user) { where(user_id: user.id) }

  def to_param
    slug
  end
end

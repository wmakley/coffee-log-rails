# frozen_string_literal: true

# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
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
  has_many :log_entries, inverse_of: :log, dependent: :restrict_with_error
  belongs_to :user, inverse_of: :log

  validates_length_of :name, :slug, maximum: 255
  validates_presence_of :name, :slug

  scope :user, ->(user) { where(user_id: user.id) }

  validate do
    if slug && slug.match?(/[^a-z0-9\-_]/)
      errors.add(:slug, "is invalid")
    end
  end

  before_validation do
    self.name = name&.squish
    self.slug = slug&.strip
  end

  def title
    "#{user.display_name}'s Log"
  end

  def to_param
    slug
  end
end

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
#
# Indexes
#
#  index_logs_on_slug  (slug) UNIQUE
#
class Log < ApplicationRecord
  has_many :log_entries, dependent: :restrict_with_error

  validates_length_of :name, :slug, maximum: 255
  validates_presence_of :name, :slug

  validate do
    if slug && slug.match?(/[^a-z0-9\-_]/)
      errors.add(:slug, "is invalid")
    end
  end

  before_validation do
    self.name = name&.squish
    self.slug = slug&.strip
  end

  def to_param
    slug
  end
end

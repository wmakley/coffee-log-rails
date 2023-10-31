# == Schema Information
#
# Table name: roasts
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roasts_on_name  (name) UNIQUE
#
class Roast < ApplicationRecord
  has_many :coffees

  normalizes :name, with: ->(name) { name.squish }

  validates :name,
    presence: true,
    length: {maximum: 100},
    uniqueness: true

  def self.for_select
    order(:id).pluck(:name, :id)
  end
end

# == Schema Information
#
# Table name: brew_methods
#
#  id                 :bigint           not null, primary key
#  default_brew_ratio :float            default(16.6667), not null
#  name               :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class BrewMethod < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }

  def self.for_select
    brew_methods = order(:id).pluck(:name, :id)
    # Move "other" to the end
    brew_methods.push brew_methods.delete_at(0)
    brew_methods
  end

  before_validation do
    self.name = name&.squish.presence
  end
end

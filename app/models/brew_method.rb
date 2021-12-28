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

  has_many :log_entries, dependent: :restrict_with_error

  before_validation do
    self.name = name&.squish.presence
  end

  validates :name,
            presence: true,
            uniqueness: true,
            length: { maximum: 100 }

  validates :default_brew_ratio,
            numericality: {
              greater_than: 0,
              less_than: 1000,
            }

  before_destroy do
    if id == 0
      errors.add(:base, "may not delete 'Other' brew method")
      throw :abort
    end
  end

  def self.for_select
    brew_methods = order(:id).pluck(:name, :id)
    # Move "other" to the end
    brew_methods.push brew_methods.delete_at(0)
    brew_methods
  end

  scope :by_name, -> { order(:name) }
end

# == Schema Information
#
# Table name: coffee_brands
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_coffee_brands_on_name  (name) UNIQUE
#
class CoffeeBrand < ApplicationRecord
  has_many :coffees, inverse_of: :coffee_brand, dependent: :restrict_with_error

  has_one_attached :logo

  validates :name, presence: true, uniqueness: true

  before_validation do
    self.name = name&.squish
    self.url = url&.squish.presence
  end
end

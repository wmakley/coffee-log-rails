# == Schema Information
#
# Table name: coffees
#
#  id              :bigint           not null, primary key
#  name            :string           not null
#  notes           :text
#  roast           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coffee_brand_id :bigint           default(0), not null
#
# Indexes
#
#  index_coffees_on_coffee_brand_id           (coffee_brand_id)
#  index_coffees_on_coffee_brand_id_and_name  (coffee_brand_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (coffee_brand_id => coffee_brands.id)
#
class Coffee < ApplicationRecord
  belongs_to :coffee_brand, inverse_of: :coffees, optional: true
  has_many :log_entries, inverse_of: :coffee, dependent: :restrict_with_error
  has_many :log_entry_versions, inverse_of: :coffee, dependent: :restrict_with_error

  has_one_attached :photo

  validates :name,
            presence: true,
            length: { maximum: 255 },
            uniqueness: { scope: :coffee_brand_id }

  before_validation do
    self.name = name&.squish
    self.notes = notes&.strip.presence
    self.roast = roast&.squish.presence
  end
end

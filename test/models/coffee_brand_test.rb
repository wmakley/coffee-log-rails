# == Schema Information
#
# Table name: coffee_brands
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  notes      :text
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_coffee_brands_on_name  (name) UNIQUE
#
require "test_helper"

class CoffeeBrandTest < ActiveSupport::TestCase
  def valid_attributes
    @counter ||= 0
    @counter += 1

    {
      name: "Test Brand #{@counter}"
    }
  end

  test "the truth" do
    coffee_brand = CoffeeBrand.new(valid_attributes)
    assert coffee_brand.save, coffee_brand.errors.full_messages.to_sentence
  end
end

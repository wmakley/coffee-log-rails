# == Schema Information
#
# Table name: coffees
#
#  id              :bigint           not null, primary key
#  decaf           :boolean
#  name            :string           not null
#  notes           :text
#  origin          :string
#  process         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  coffee_brand_id :bigint           default(0), not null
#  roast_id        :bigint
#
# Indexes
#
#  index_coffees_on_coffee_brand_id           (coffee_brand_id)
#  index_coffees_on_coffee_brand_id_and_name  (coffee_brand_id,name) UNIQUE
#  index_coffees_on_roast_id                  (roast_id)
#
# Foreign Keys
#
#  fk_rails_...  (coffee_brand_id => coffee_brands.id)
#  fk_rails_...  (roast_id => roasts.id)
#
require "test_helper"

class CoffeeTest < ActiveSupport::TestCase

  def valid_attributes
    {
      coffee_brand: coffee_brands(:default),
      name: "Test Coffee"
    }
  end

  test "it saves with valid attributes" do
    coffee = Coffee.new(valid_attributes)
    assert coffee.save, coffee.errors.full_messages.to_sentence
  end

  test "input normalization" do
    coffee = Coffee.new
    coffee.name = " fu   bar "
    coffee.valid?
    assert_equal "fu bar", coffee.name

    coffee.notes = "line1\r\nline2\t"
    coffee.valid?
    assert_equal "line1\nline2", coffee.notes

    coffee.notes = " line1\rline2 "
    coffee.valid?
    assert_equal "line1\nline2", coffee.notes

    coffee.notes = "line1\n\nline2"
    coffee.valid?
    assert_equal "line1\n\nline2", coffee.notes
  end

  test "name validation" do
    coffee = Coffee.new
    coffee.name = "<?12345"
    assert_not coffee.valid?
    coffee.name = "12345?>"
    assert_not coffee.valid?
    coffee.name = "<?12345?>"
    assert_not coffee.valid?
  end
end

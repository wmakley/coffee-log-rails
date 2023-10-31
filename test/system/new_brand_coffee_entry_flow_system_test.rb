# frozen_string_literal: true

require "application_system_test_case"

class NewBrandCoffeeEntryFlowSystemTest < ApplicationSystemTestCase
  setup do
    login_as users(:default)
  end

  test "creating a new brand, coffee, and entry" do
    visit "/"

    click_link "Brands"
    click_link "Add New Coffee Brand"
    assert_current_path "/coffee_brands/new"

    fill_in "Name", with: "Test Brand #{random_string(8)}"
    click_button "Create Coffee Brand"
    assert_current_path %r{\A/coffee_brands/\d+\z}
    assert_notice "Successfully created coffee brand."

    click_link "Add Coffee"
    assert_current_path %r{\A/coffees/new\?coffee_brand_id=\d+\z}
    fill_in "Name", with: "Test Coffee #{random_string(8)}"
    click_button "Create Coffee"
    assert_current_path %r{\A/coffees/\d+\z}
    assert_notice "Successfully created coffee."

    click_link "Add Log Entry"
    assert_current_path %r{\A/logs/default/entries/new\?.*coffee_id=\d+}
  end
end

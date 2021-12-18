# frozen_string_literal: true

require "application_system_test_case"

class LogEntriesSystemTest < ApplicationSystemTestCase
  fixtures :users, :logs, :coffee_brands, :coffees, :brew_methods

  setup do
    login_as users(:default)
  end

  test "creating a new log entry" do
    visit "/logs/default/entries"
    assert_current_path "/logs/default/entries"

    assert_selector "h1", text: "Default's Log Entries"

    fill_in "Start by typing the name of your coffee:", with: "coffee"
    first(:css, "##{dom_id(coffees(:one))}-search-result").click
    select "French Press", from: "Brew Method"
    fill_in "Coffee grams", with: "10"
    fill_in "Water grams", with: "100"
    fill_in "Grind Notes", with: "some notes"
    click_button "Create Log Entry"

    refute_selector "#no_log_entries_message"

    assert_selector "#log_entries > a.list-group-item"

    within first(:css, "#log_entries > a.list-group-item") do
      assert_content "#{coffees(:one).name} (French Press - 10/100 - 1 : 10.0)"
    end
  end

  test "coffee lookup persistence" do
    coffee = coffees(:one)

    visit "/logs/default/entries"
    fill_in "Start by typing the name of your coffee:", with: "coffee"
    first(:css, "##{dom_id(coffee)}-search-result").click

    assert_selector ".selected-coffee-card"
    assert_selector ".selected-coffee-card .card-title", text: coffee.name
    first(:css, ".selected-coffee-card").click
    assert_current_path %r{\A/coffees/#{coffee.id}}

    click_link "Back"
    assert_current_path %r{\A/logs/default/entries}
    assert_equal "coffee", find(:css, "#lookup_coffee_form_query").value
    assert_selector "##{dom_id(coffee)}-search-result"
    assert_selector ".selected-coffee-card .card-title", text: coffee.name
  end
end

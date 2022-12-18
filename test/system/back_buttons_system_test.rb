# frozen_string_literal: true

require 'application_system_test_case'

class BackButtonsSystemTest < ApplicationSystemTestCase
  # fixtures :all

  setup do
    login_as users(:default)
  end

  test "log entry back button behavior with context" do
    entry = log_entries(:one)
    visit "/logs/default/entries"
    first(:css, "a##{dom_id(entry)}").click
    assert_current_path "/logs/default/entries/#{entry.to_param}"
    click_link "Back"
    assert_current_path "/logs/default/entries"
  end

  test "log entry back button behavior without context" do
    visit "/logs/default/entries/1"
    click_link "Back"
    assert_current_path "/logs/default/entries"
  end

  test "log entry back button behavior after edit" do
    visit "/logs/default/entries/1/edit"
    click_button "Update Log Entry"
    click_link "Back"
    assert_current_path "/logs/default/entries"
  end

  test "log entry back button from coffee" do
    log_entry = log_entries(:one)
    visit coffee_path(log_entry.coffee)
    click_link "#{log_entry.log.title}: #{log_entry.entry_date.to_formatted_s(:short)}"
    click_link "Back"
    assert_current_path coffee_path(log_entry.coffee)
  end

  test "chained back links don't make a loop" do
    skip "TODO"

    log_entry = log_entries(:one)

    visit coffees_path
    first(:css, %(a[href="#{coffee_path(log_entry.coffee)}"])).click
    click_link "#{log_entry.log.title}: #{log_entry.entry_date.to_formatted_s(:short)}"
    click_link "Back"
    assert_current_path coffee_path(log_entry.coffee)
    click_link "Back"
    assert_current_path coffees_path
  end
end

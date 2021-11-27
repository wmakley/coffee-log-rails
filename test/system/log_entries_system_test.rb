# frozen_string_literal: true

require "application_system_test_case"

class LogEntriesSystemTest < ApplicationSystemTestCase
  fixtures :users, :logs

  setup do
    @user = users(:default)
  end

  test "creating a new log entry" do
    visit "/logs/default/entries"
    assert_current_path "/logs/default/entries"

    assert_selector "h1", text: "Default's Log Entries"
    assert_selector "#no_log_entries_message", text: "There are no log entries yet."

    within "form.log-entry-form" do
      fill_in "Coffee", with: "Crazy Coffee"
      select "French Press", from: "Brew Method"
      click_button "Create Log Entry"
    end

    refute_selector "#no_log_entries_message"

    assert_selector "#log_entries > a.list-group-item", count: 1

    within "#log_entries > a.list-group-item" do
      assert_content "Crazy Coffee"
    end
  end
end

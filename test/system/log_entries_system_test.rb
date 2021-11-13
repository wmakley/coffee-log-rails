require "application_system_test_case"

class LogEntriesSystemTest < ApplicationSystemTestCase
  fixtures :all

  setup do
    @user = users(:default)
  end

  test "creating a new log entry" do
    visit_with_basic_auth "/logs/default/entries"
    assert_current_path "/logs/default/entries"

    within "form.log-entry-form" do
      fill_in "Coffee", with: "Test Coffee"
      click_button "Create Log Entry"
    end
  end
end

# frozen_string_literal: true

require "application_system_test_case"

class SessionsSystemTest < ApplicationSystemTestCase
  test "logging in with valid credentials and logging out" do
    visit "/"
    fill_in "Username", with: TEST_USERNAME
    fill_in "Password", with: TEST_PASSWORD
    click_button "Login"

    assert_current_path "/logs/default/entries"

    click_button "Logout"
    assert_current_path "/session/new"
  end
end

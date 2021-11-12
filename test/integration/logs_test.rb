# frozen_string_literal: true

require 'test_helper'

class LogsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "index redirects to the user's log" do
    get "/logs", headers: valid_login
    assert_redirected_to "/logs/default/entries"
  end

  test "index creates a new log for the user if doesn't exist" do
    user = User.create!(
      display_name: "Test User",
      username: "test",
      password: "test"
    )

    get "/logs", headers: authorization_header("test", "test")

    assert_redirected_to "/logs/test/entries"
    follow_redirect! headers: authorization_header("test", "test")
    assert_response :success
  end
end

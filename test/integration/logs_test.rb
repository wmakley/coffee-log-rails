# frozen_string_literal: true

require "test_helper"

class LogsTest < ActionDispatch::IntegrationTest
  test "index redirects to the user's log" do
    login_as users(:default)
    get "/logs"
    assert_redirected_to "/logs/default/entries"
  end

  test "index creates a new log for the user if doesn't exist" do
    user = User.create!(
      display_name: "Test User",
      email: random_email,
      password: "testtestest",
    )
    login_as user

    get "/logs"

    assert_redirected_to "/logs/#{user.short_username}/entries"
    follow_redirect!
    assert_response :success
  end

  test "user may only visit logs for groups they are a member of" do
    login_as users(:group_a)

    get "/logs/group-a/entries"
    assert_response :success

    get "/logs/group-b/entries"
    assert_response :not_found
  end
end

# frozen_string_literal: true

require 'test_helper'

class SessionsTest < ActionDispatch::IntegrationTest
  # fixtures :all

  def valid_login_params
    {
      login_form: {
        username: TEST_USERNAME,
        password: TEST_PASSWORD,
      },
    }
  end

  test "logging in with valid credentials" do
    get "/session/new"
    assert_response :success
    assert_select "h1", text: "Login to Coffee Log"
    assert_select "form"

    post "/session", params: valid_login_params
    assert cookies[:sess].present?, "authentication cookie not set"
    assert_redirected_to "/logs", status: :see_other
  end

  test "accessing pages that require login with valid session" do
    post "/session", params: valid_login_params
    get "/logs/default/entries"
    assert_response :success
  end

  test "accessing pages that require login without a valid session redirects to login page" do
    get "/logs/default/entries"
    assert_redirected_to "/session/new"
  end

  test "logging out" do
    post "/session", params: valid_login_params
    delete "/session"
    assert_redirected_to "/session/new", status: :see_other
    follow_redirect!
    assert_response :success
    assert_select "h1", text: "Login to Coffee Log"
    assert_select "form"

    get "/logs/default/entries"
    assert_redirected_to "/session/new"
  end

  test "sessions expire after 1 month" do
    post "/session", params: valid_login_params
    assert_redirected_to "/logs", status: :see_other

    Timecop.travel 1.week.from_now do
      get "/logs/default/entries"
      assert_response :success
    end

    Timecop.travel 2.weeks.from_now do
      get "/logs/default/entries"
      assert_response :success
    end

    Timecop.travel 3.weeks.from_now do
      get "/logs/default/entries"
      assert_response :success
    end

    Timecop.travel 31.days.from_now do
      get "/logs/default/entries"
      assert_redirected_to "/session/new"
    end
  end
end

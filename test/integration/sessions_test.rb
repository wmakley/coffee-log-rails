# frozen_string_literal: true

require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  def setup
    super
    CaptchaWrapper.captcha_implementation = :always_succeed
  end

  def valid_login_params
    {
      login_form: {
        username: users(:default).username,
        password: TEST_PASSWORD,
      },
    }
  end

  def invalid_password_params
    {
      login_form: {
        username: users(:default).username,
        password: "24435345",
      },
    }
  end

  def invalid_username_params
    {
      login_form: {
        username: "somebody",
        password: TEST_PASSWORD,
      },
    }
  end

  def unverified_email_user_login_params
    {
      login_form: {
        username: users(:unverified_email).username,
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

  test "invalid password may not log in" do
    post "/session", params: invalid_password_params
    assert_response :unprocessable_content
    assert cookies[:sess].blank?
  end

  test "invalid username may not log in" do
    post "/session", params: invalid_username_params
    assert_response :unprocessable_content
    assert cookies[:sess].blank?
  end

  test "may not login on CAPTCHA failure" do
    CaptchaWrapper.captcha_implementation = :always_fail
    post "/session", params: valid_login_params
    assert_response :unprocessable_content
    assert cookies[:sess].blank?
    assert_includes flash["error"], "ReCAPTCHA"
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

  test "users with unverified email are allowed to login, but may not access app until they verify email" do
    assert_emails 1 do
      post "/session", params: unverified_email_user_login_params
    end
    assert_redirected_to "/session/new"
    follow_redirect!
    assert_error "Your email address has not been verified. Please click the link in your email to continue."

    get "/logs/default/entries"
    assert_redirected_to "/session/new"
  end
end

# frozen_string_literal: true

require "test_helper"

class PasswordResetRequestsTest < ActionDispatch::IntegrationTest
  test "forgot password with valid email" do
    user = users(:default)

    get "/password_reset_request/new"
    assert_response :success
    assert_select "form"

    assert_emails 1 do
      post "/password_reset_request", params: {
        password_reset_request: {
          email: user.email,
        },
      }
    end
    assert_redirected_to "/"
    follow_redirect!
    assert_notice "A reset link has been sent to your email address."

    user.reload
    old_password = user.password_digest

    get "/password/edit", params: {token: user.reset_password_token}
    assert_response :success
    assert_select "form"

    patch "/password", params: {
      password_reset: {
        token: user.reset_password_token,
        password: "NEW_PASSWORD",
        password_confirmation: "NEW_PASSWORD",
      },
    }

    assert_redirected_to "/session/new"
    follow_redirect!
    assert_notice "Successfully reset password. Please login with your new password."

    user.reload
    new_password = user.password_digest

    assert_not_equal old_password, new_password
    assert_nil user.reset_password_token
    assert_nil user.reset_password_token_created_at
  end
end

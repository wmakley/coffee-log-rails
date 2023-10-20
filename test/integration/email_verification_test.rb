require 'test_helper'

class EmailVerificationTest < ActionDispatch::IntegrationTest
  def unverified_email_user_login_params
    {
      login_form: {
        username: users(:unverified_email).username,
        password: TEST_PASSWORD,
      }
    }
  end

  test "verifying email address when not logged in success" do
    user = users(:unverified_email)
    user.generate_new_verification_token_and_send_email!

    get "/email-verification"
    assert_redirected_to "/email-verification/new"

    get "/email-verification/new", params: {
      email: user.email,
      token: user.email_verification_token,
    }

    assert_redirected_to_login
    follow_redirect!
    assert_response :success
    assert_notice "Your email has been successfully verified!"
  end

  test "verifying email address when already logged in success" do
    user = users(:unverified_email)
    user.generate_new_verification_token_and_send_email!

    login_as user

    get "/email-verification"
    assert_redirected_to "/email-verification/new"

    get "/email-verification/new", params: {
      email: user.email,
      token: user.email_verification_token,
    }

    assert_redirected_to_app
    follow_redirect!
    assert_response :success
    assert_notice "Your email has been successfully verified!"
  end

  test "login form re-sends verification emails for users that have not verified yet" do
    user = users(:post_migration_email_not_verified)

    assert_emails 1 do
      post "/session", params: {
        login_form: {
          username: user.username,
          password: 'password',
        }
      }
    end
    assert_redirected_to "/session/new", status: :see_other
    assert_equal "Your email address has not been verified. Please click the link in your email to continue.", flash[:error]

    user.reload
    assert_not_nil user.verification_email_sent_at
    assert user.email_verification_token.present?
  end
end

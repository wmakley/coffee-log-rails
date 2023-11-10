# frozen_string_literal: true

require "test_helper"

class MyAccountTest < ActionDispatch::IntegrationTest
  setup do
    @user = login_as users(:non_admin)
  end

  test "show" do
    get "/my_account"
    assert_response :success
    assert_select "h1", "My Account"
  end

  test "updating email requires verification" do
    old_email = @user.email
    new_email = "new_email@test.com"
    assert_not_equal new_email, old_email # sanity check

    assert_emails 1 do
      patch "/my_account", params: {
        my_account: {
          email: "new_email@test.com",
        },
      }
    end

    @user.reload
    assert_equal new_email, @user.new_email
    assert_equal old_email, @user.email
    assert @user.email_verification_token.present?, "expected verification token to have been generated"
    assert @user.verification_email_sent_at.present?, "expected verification email to have been sent"
  end

  test "updating password" do
    patch "/my_account", params: {
      my_account: {
        password: "testtesttesttest",
        password_confirmation: "testtesttesttest",
      },
    }
    assert_redirected_to "/my_account"
    follow_redirect!
    assert_select "#flash > .alert.alert-success", 1, "Successfully updated account."
  end

  test "may not update password without confirmation" do
    patch "/my_account", params: {
      my_account: {
        password: "testtesttesttest",
      },
    }
    assert_response :unprocessable_entity
  end

  test "may not make self an admin" do
    patch "/my_account", params: {
      my_account: {
        admin: "1",
      },
    }
    assert_redirected_to "/my_account"
    user = users(:non_admin)
    user.reload
    assert_not user.admin?
  end
end

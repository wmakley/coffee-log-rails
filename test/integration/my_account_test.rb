# frozen_string_literal: true

require "test_helper"

class MyAccountTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:non_admin)
  end

  test "show" do
    get "/my_account"
    assert_response :success
    assert_select "h1", "My Account"
  end

  test "updating password" do
    patch "/my_account", params: {
      user: {
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
      user: {
        password: "testtesttesttest",
      },
    }
    assert_response :unprocessable_entity
  end

  test "may not make self an admin" do
    patch "/my_account", params: {
      user: {
        admin: "1",
      },
    }
    assert_redirected_to "/my_account"
    user = users(:non_admin)
    user.reload
    assert_not user.admin?
  end
end

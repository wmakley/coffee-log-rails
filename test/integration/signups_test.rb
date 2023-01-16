# frozen_string_literal: true

require "test_helper"

class SignupsTest < ActionDispatch::IntegrationTest
  test "can use code to sign up to a group" do
    get "/signup"
    assert_redirected_to "/signup/new"

    follow_redirect!
    assert_response :success

    assert_select "form#new_signup"
  end
end

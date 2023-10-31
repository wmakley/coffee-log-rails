# frozen_string_literal: true

require "test_helper"

class SignupsTest < ActionDispatch::IntegrationTest
  def valid_signup_form_params
    {
      code: signup_codes(:active).code,
      new_email: "test@#{SecureRandom.hex(8)}.com",
      display_name: "Test Testerson #{SecureRandom.hex(8)}",
      password: "asdf23434",
      password_confirmation: "asdf23434",
    }
  end

  test "can use code to sign up to a group" do
    get "/signup"
    assert_redirected_to "/signup/new"

    follow_redirect!
    assert_response :success
    assert_select "form#new_signup_form"

    assert_emails 1 do
      post "/signup", params: {
        signup_form: valid_signup_form_params,
      }
    end
    assert_redirected_to "/signup/success"
    follow_redirect!
    assert_response :success
    assert_select "h1", count: 1, text: "Your account is almost ready!"
  end
end

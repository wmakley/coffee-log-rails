# frozen_string_literal: true

require "application_system_test_case"

class SignupsSystemTest < ApplicationSystemTestCase
  test "signing up using an active code" do
    signup_code = signup_codes(:active)

    visit "/"
    click_link "Sign up!"
    assert_current_path "/signup/new"

    fill_in "Code", with: signup_code.code
    fill_in "Email", with: "test@example.com"
    fill_in "Display Name", with: "Test Testerson"
    fill_in "Password", with: "asdf1234"
    fill_in "Password Confirmation", with: "asdf1234"

    click_button "Create Account"

    assert_current_path "/signup/success"
    assert_content "Your account is almost ready!"

    user = User.last
    assert user.email_verification_token.present?

    visit new_auth_email_verification_path(email: user.email, token: user.email_verification_token)
    # visit "/email-verification/new?email=#{user.email}&token=#{user.email_verification_token}"
    assert_current_path %r{/session/new}
    assert_notice "Your email has been successfully verified!"
  end
end

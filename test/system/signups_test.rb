# frozen_string_literal: true

class SignupsTest < ApplicationSystemTestCase
  test "signing up using an active code" do
    signup_code = signup_codes(:active)

    visit "/"
    click_link "Sign up"
    assert_current_path "/signup"

    fill_in "Code", with: signup_code.code
    fill_in "Email", with: "test@example.com"

    assert_emails 1 do
      click_button "Signup"
    end

    assert_content "An activation link has been sent to test@example.com! It will expire in one hour."

    user = User.order(id: :desc).first
    assert user.activation_code.present?

    visit "/signup?activation_code=#{user.activation_code}"
  end
end

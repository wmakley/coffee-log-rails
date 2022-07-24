require "test_helper"

class PasswordResetRequestMailerTest < ActionMailer::TestCase
  fixtures :users

  test "reset_password_link" do
    user = users(:default)
    user.generate_reset_password_token! # without saving
    email = PasswordResetRequestMailer.with(user: user).reset_password_link

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["noreply@coffee-log.willmakley.dev"], email.from
    assert_equal [user.email], email.to
    assert_equal "Reset Coffee Log Password", email.subject

    assert_includes email.html_part.body.to_s, "<h2>Click this link to reset your Coffee Log password:</h2>"
    assert_includes email.text_part.body.to_s, "Visit this URL to reset your password:"
  end
end

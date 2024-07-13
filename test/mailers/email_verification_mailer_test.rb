require "test_helper"

class EmailVerificationMailerTest < ActionMailer::TestCase
  test "verification_link" do
    user = users(:unverified_email)

    email = EmailVerificationMailer.with(user: user).verification_link

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["noreply@coffee-log.willmakley.dev"], email.from
    assert_equal [user.email], email.to
    assert_equal "Verify Your Coffee Log Email", email.subject
  end
end

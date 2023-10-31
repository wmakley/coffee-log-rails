require "test_helper"

class PasswordResetRequestTest < ActiveSupport::TestCase
  def assert_reset_token_set(user)
    assert_not_nil user.reset_password_token
    assert_not_nil user.reset_password_token_created_at
  end

  test "happy path" do
    user = users(:default)
    assert user.email.present?

    request = PasswordResetRequest.new(email: user.email)
    assert request.valid?
    assert request.save, request.errors.full_messages

    user.reload
    assert_reset_token_set user
  end

  test "email is not case-sensitive" do
    user = users(:default)
    assert_nil user.reset_password_token

    request = PasswordResetRequest.new(email: user.email.upcase)
    assert request.valid?
    assert request.save, request.errors.full_messages

    user.reload
    assert_reset_token_set user
  end

  test "invalid email still returns true" do
    request = PasswordResetRequest.new(email: "test@#{random_string(12)}")
    assert request.valid?
    assert request.save
    assert request.invalid_email?
    assert_nil User.where.not(reset_password_token: nil).first
  end
end

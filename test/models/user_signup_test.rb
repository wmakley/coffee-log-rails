# frozen_string_literal: true

require "test_helper"

class UserSignupTest < ActiveSupport::TestCase
  def valid_attributes
    {
      code: signup_codes(:active).code,
      new_email: "test@example.com",
      display_name: "Test Testerson",
      password: "asdf1234",
      password_confirmation: "asdf1234",
    }
  end

  def invalid_attributes
    {}
  end

  test "it saves with valid attributes" do
    form = UserSignup.new(valid_attributes)
    assert form.valid?, "form wasn't valid"
    assert form.save, "valid form did not save"
    assert_equal User.last, form.user
  end

  test "invalid forms do not save or create users" do
    form = UserSignup.new(invalid_attributes)
    assert_not form.valid?, "form was valid"

    assert_no_changes -> { User.count } do
      assert_not form.save, "valid form saved"
    end

    assert_nil form.user
  end

  test "valid forms create new user with an email verification token" do
    form = UserSignup.new(valid_attributes)

    initial_user_count = User.count
    assert form.save
    assert_equal initial_user_count + 1, User.count

    user = User.last
    assert user.email_verification_token.present?
    assert_equal user, form.user
  end

  test "created user is associated with the signup code's group" do
    form = UserSignup.new(valid_attributes)

    assert form.save

    user = User.last
    assert_equal 1, user.group_memberships.size
    assert_equal user.group_memberships.first.user_group, signup_codes(:active).user_group
  end

  test "user errors are bubbled up to the form" do
    form = UserSignup.new(
      valid_attributes.merge(
        password: "  a  ", # User validates passwords
      ),
    )
    assert form.valid?

    assert_not form.save
    assert form.errors[:password].present?
  end
end

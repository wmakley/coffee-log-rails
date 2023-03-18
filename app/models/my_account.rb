# frozen_string_literal: true

# Decorator for User that applies "my account" form business rules.
class MyAccount
  def initialize(user = Current.user)
    @user = user or fail "user not set"
  end

  delegate_missing_to :@user

  def email
    @user.new_email.presence || @user.email
  end

  def email=(input)
    @user.new_email = input
  end

  def username=(input)
    raise ArgumentError, "not permitted"
  end

  def email_verified?
    @user.new_email.blank? && @user.email_verified_at.present?
  end

  def save
    @user.save
  end
end

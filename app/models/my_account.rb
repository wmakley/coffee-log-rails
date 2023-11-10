# frozen_string_literal: true

# Decorator for User that applies "my account" form business rules.
class MyAccount
  include ActiveModel::Model

  def initialize(user = Current.user)
    @user = user or fail "user not set"
  end

  attr_reader :user

  delegate :id,
    :display_name, :display_name=,
    :password, :password=,
    :password_confirmation, :password_confirmation=,
    :email_verified?,
    :valid?, :invalid?, :errors, :persisted?,
    to: :user

  def email
    @user.new_email.presence || @user.email
  end

  def email=(input)
    @user.new_email = input
  end

  # On my account screen, email is simply not verified if new_email is present.
  def email_verified?
    @user.new_email.blank? && @user.email_verified_at.present?
  end

  def update(attributes)
    self.attributes = attributes
    save
  end

  def save
    return false if user.invalid?

    if user.new_email_changed?
      user.start_verification_process!
    end

    user.save or return false

    user.send_verification_email
    true
  end
end

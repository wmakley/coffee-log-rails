# frozen_string_literal: true
# typed: true

# Decorator for User that applies "my account" form business rules.
class MyAccount
  extend T::Sig
  include ActiveModel::Model

  def initialize(user = Current.user)
    @user = T.let(user, User)
  end

  sig { returns(User) }
  attr_reader :user

  delegate :id,
    :display_name, :display_name=,
    :password, :password=,
    :password_confirmation, :password_confirmation=,
    :each_user_group_and_membership, :group_memberships,
    :valid?, :invalid?, :errors, :persisted?,
    to: :user

  sig { returns T.nilable(String) }
  def email
    @user.new_email.presence || @user.email
  end

  sig { params(input: T.nilable(String)).returns(T.nilable(String)) }
  def email=(input)
    @user.new_email = input
  end

  # On my account screen, email is simply not verified if new_email is present.
  sig { returns(T::Boolean) }
  def email_verified?
    @user.new_email.blank? && @user.email_verified_at.present?
  end

  sig { params(attributes: T.any(Hash, ActiveSupport::HashWithIndifferentAccess)).returns(T::Boolean) }
  def update(attributes)
    self.attributes = attributes
    save
  end

  sig { returns(T::Boolean) }
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

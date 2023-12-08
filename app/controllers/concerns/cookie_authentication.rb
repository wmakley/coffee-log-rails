# frozen_string_literal: true

module CookieAuthentication
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  class NotAuthenticatedError < AuthenticationError; end

  class SessionExpiredError < AuthenticationError; end

  class PasswordChangedError < AuthenticationError; end

  class EmailVerificationNeededError < AuthenticationError
    def initialize(user)
      super("Email address not verified")
      @user = user
    end

    attr_reader :user
  end

  included do
    helper_method :current_user
    helper_method :authenticated?

    mattr_accessor :stub_current_user if Rails.env.test?
  end

  def current_user
    Current.user
  end

  def authenticated?
    current_user.present?
  end

  def soft_authenticate_user_from_session
    logger.info "#soft_authenticate_user_from_session"
    begin
      authenticate_user_from_session!
    rescue AuthenticationError => ex
      logger.info "Unable to authenticate user: #{ex.message}"
      false
    end
  end

  # TODO: may be a good idea to reset the session on failure
  def authenticate_user_from_session!
    logger.info "#authenticate_user_from_session!"
    if Rails.env.test? && stub_current_user
      Current.user = stub_current_user
      return Current.user
    end

    cookie = read_authentication_cookie
    raise NotAuthenticatedError, "no session cookie" if cookie.blank?

    user_id = cookie[:user_id]
    raise NotAuthenticatedError, "user_id not found in session" if user_id.blank?

    user = User.find_by(id: user_id)
    raise NotAuthenticatedError, "User ID #{user_id} not found" if user.nil?

    last_login_at = Time.at(cookie[:last_login_at].to_i)

    if last_login_at.before? 30.days.ago
      raise SessionExpiredError, "Last logged in more than 1 month ago"
    end

    if last_login_at.before? user.password_changed_at
      raise PasswordChangedError, "Password changed since last login"
    end

    if user.needs_email_verification?
      raise EmailVerificationNeededError.new(user)
    end

    Current.user = user
  end

  # @param [LoginForm] login_form
  def authenticate_user_from_form(login_form)
    logger.info "#authenticate_user_from_form"
    unless login_form.valid?
      logger.info "login_form is not valid: #{login_form.errors.full_messages.inspect}"
      return false
    end

    username = login_form.username.to_s.downcase

    user = User.authenticate_by(username: username, password: login_form.password.to_s)
    unless user
      logger.warn "invalid username or password"
      return false
    end

    logger.info "Authenticated user as #{user.username}:#{user.id}"

    reset_session
    set_authentication_cookie(user.id)
    user.update_column(:last_login_at, Time.current) # must not fail
    Current.user = user

    # If the user needs to verify their email, they are already authenticated so they
    # can go straight to the app after they click the verification link.

    if user.needs_email_verification?
      raise EmailVerificationNeededError.new(user)
    end

    user
  end

  def read_authentication_cookie(raise_errors: Rails.env.development? || Rails.env.test?)
    raw_cookie = cookies.encrypted[:sess]
    logger.debug "Raw Session Cookie: #{raw_cookie.inspect}"
    return nil unless raw_cookie

    cookie = JSON.parse(raw_cookie)
    unless cookie.is_a?(Hash)
      msg = "authentication cookie is not a Hash"
      logger.error msg
      raise msg if raise_errors
      cookies.delete(:sess)
      return nil
    end

    begin
      cookie.assert_valid_keys("user_id", "last_login_at")
    rescue ArgumentError
      msg = "authentication cookie did not have expected structure"
      logger.error msg
      raise msg if raise_errors
      return nil
    end

    ActiveSupport::HashWithIndifferentAccess.new(cookie)
  end

  def set_authentication_cookie(user_id)
    cookie = {
      "user_id" => user_id,
      "last_login_at" => Time.now.utc.to_i,
    }
    serialized_cookie = JSON.generate(cookie)
    logger.debug "Set Auth Cookie to: #{serialized_cookie}"
    cookies.encrypted[:sess] = {
      value: serialized_cookie,
      expires: 30.days,
      samesite: :lax,
      httponly: true,
      secure: Rails.env.production? || Rails.env.fly?,
    }
  end

  def delete_authentication_cookie
    cookies.delete(:sess)
  end

  def logout_current_user
    reset_session
    cookies.delete(:sess)
  end
end

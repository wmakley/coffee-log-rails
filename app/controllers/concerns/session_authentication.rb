# frozen_string_literal: true

module SessionAuthentication
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end

  class NotAuthenticatedError < AuthenticationError; end
  class SessionExpiredError < AuthenticationError; end
  class PasswordChangedError < AuthenticationError; end

  included do
    helper_method :current_user
    helper_method :authenticated?

    mattr_accessor :stub_current_user if Rails.env.test?
  end

  def current_user
    Current.user
  end

  def authenticated?
    !!Current.user
  end

  def soft_authenticate_user_from_session
    logger.debug "in #soft_authenticate_user_from_session"
    begin
      authenticate_user_from_session!
    rescue AuthenticationError => ex
      logger.info ex.message
      return false
    end
  end

  def authenticate_user_from_session!
    logger.debug "in #authenticate_user_from_session!"
    if Rails.env.test? && stub_current_user
      Current.user = stub_current_user
      return
    end

    user_id = session[:logged_in_user_id]
    raise NotAuthenticatedError, "logged_in_user_id not found in session" unless user_id

    user = User.find_by(id: user_id)
    raise NotAuthenticatedError, "User ID #{user_id} not found" unless user

    last_login_at = Time.at(session[:last_login_at].to_i)

    if last_login_at < 1.month.ago
      raise SessionExpiredError, "Last logged in more than 1 month ago"
    end

    if last_login_at < user.password_changed_at
      raise PasswordChangedError, "Password changed since last login"
    end

    Current.user = user
  end

  # @param [LoginForm] login_form
  def authenticate_user_from_form(login_form)
    return false unless login_form.valid?

    user = User.find_by(username: login_form.username.to_s)
    unless user
      logger.warn "username '#{login_form.username}' not found"
      return false
    end

    unless user.authenticate(login_form.password.to_s)
      logger.warn "invalid password"
      return false
    end

    logger.info "Authenticated user as #{user.username}:#{user.id}"

    reset_session
    session[:logged_in_user_id] = user.id
    session[:last_login_at] = Time.now.utc.to_i
    Current.user = user
  end

  def logout_current_user
    session.delete(:logged_in_user_id)
    session.delete(:last_login_at)
  end
end

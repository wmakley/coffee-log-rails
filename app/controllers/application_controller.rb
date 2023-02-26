# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :error, :warning

  before_action :redirect_to_https, unless: -> { request.ssl? || request.local? }

  include Pundit::Authorization
  include IpBanningConcern
  include CookieAuthentication

  before_action :cleanup_old_sessions

  rescue_from AuthenticationError do |exception|
    session[:return_to] = request.url
    logger.error exception.message

    if exception.is_a? EmailVerificationNeededError
      flash[:error] = "Your email address has not been verified. Please click the link in your email to continue."
    else
      flash[:error] = "Not authorized"
    end

    redirect_to new_auth_session_url, status: :see_other
  end

  def self.requires_admin(*actions)
    before_action only: actions do
      unless current_user&.admin?
        flash[:error] = "Not authorized"
        redirect_to root_url, status: :see_other
      end
    end
  end

  private

    def cleanup_old_sessions
      session.delete(:username)
      session.delete(:password)
    end

    def redirect_to_https
      redirect_to protocol: "https://", status: :moved_permanently
    end

    def redirect_to_app
      redirect_to logs_url, status: :see_other
    end

    def redirect_to_login
      redirect_to new_auth_session_url, status: :see_other
    end
end

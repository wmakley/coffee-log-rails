# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :error, :warning

  include IpBanningConcern
  include CookieAuthentication

  before_action :cleanup_old_sessions
  # before_action :set_paper_trail_whodunnit

  rescue_from AuthenticationError do |exception|
    session[:return_to] = request.url
    logger.error exception.message

    if exception.is_a? EmailVerificationNeededError
      user = exception.user
      flash[:error] = "Your email address has not been verified. Please click the link in your email to continue."
      unless user.verification_email_sent?
        user.generate_new_verification_token_and_send_email!
      end
    else
      flash[:error] = "Not authorized"
    end

    redirect_to new_auth_session_url, status: :see_other
  end

  private

    def cleanup_old_sessions
      session.delete(:username)
      session.delete(:password)
    end

    def redirect_to_app
      redirect_to logs_url, status: :see_other
    end

    def redirect_to_login
      redirect_to new_auth_session_url, status: :see_other
    end
end

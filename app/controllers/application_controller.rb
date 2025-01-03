# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  add_flash_types :error, :warning

  include IpBanningConcern
  include CookieAuthentication
  include CaptchaWrapper

  # before_action :set_paper_trail_whodunnit

  rescue_from AuthenticationError do |exception|
    session[:return_to] = request.url
    logger.error exception.message

    if exception.is_a? EmailVerificationNeededError
      flash[:error] = "Your email address has not been verified. Please click the link in your email to continue."
      exception.user.email_verification_flow.send_verification_email_if_not_sent_recently!
    else
      reset_session
      delete_authentication_cookie
      flash[:error] = "Not authorized."
    end

    redirect_to new_auth_session_url, status: :see_other
  end

  private

  def redirect_to_app
    redirect_to logs_url, status: :see_other
  end

  def redirect_to_login
    redirect_to new_auth_session_url, status: :see_other
  end
end

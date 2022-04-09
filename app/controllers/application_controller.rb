# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :error, :warning

  before_action :redirect_to_https, unless: -> { request.ssl? || request.local? }

  include IpBanningConcern
  include SessionAuthentication

  before_action :cleanup_old_sessions
  before_action :authenticate_user_from_session!
  before_action :set_logs
  before_action :set_paper_trail_whodunnit

  rescue_from AuthenticationError do |exception|
    session[:return_to] = request.url
    logger.error exception.message
    flash[:error] = "Not authorized"
    redirect_to new_session_url
  end

  def self.requires_admin(*actions)
    before_action only: actions do
      unless current_user&.admin?
        flash[:error] = "Not authorized"
        redirect_to root_url
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

    def set_logs
      @logs = Log.all
    end
end

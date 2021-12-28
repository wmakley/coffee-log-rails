# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :error, :warning

  before_action :redirect_to_https, unless: -> { request.ssl? || request.local? }

  include IpBanningConcern
  include HttpBasicAuthentication

  before_action :set_logs

  def self.requires_admin(*actions)
    before_action only: actions do
      unless current_user&.admin?
        flash[:error] = "Not authorized"
        redirect_to root_url
      end
    end
  end

  private

    def redirect_to_https
      redirect_to protocol: "https://", status: :moved_permanently
    end

    def set_logs
      @logs = Log.all
    end
end

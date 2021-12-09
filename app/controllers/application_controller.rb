# frozen_string_literal: true

class ApplicationController < ActionController::Base

  before_action :redirect_to_https, unless: -> { request.ssl? || request.local? }
  include IpBanningConcern
  include HttpBasicAuthentication

  before_action :set_logs

  private

    def redirect_to_https
      redirect_to protocol: "https://", status: :moved_permanently
    end

    def set_logs
      @logs = Log.all
    end
end

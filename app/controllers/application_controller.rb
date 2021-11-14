class ApplicationController < ActionController::Base
  include IpBanningConcern
  include HttpBasicAuthentication

  before_action :redirect_to_https, unless: -> { request.ssl? || request.local? }
  before_action :set_logs

  private

    def redirect_to_https
      redirect_to protocol: "https://"
    end

    def set_logs
      @logs = Log.all
    end
end

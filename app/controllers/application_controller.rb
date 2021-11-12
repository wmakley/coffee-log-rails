class ApplicationController < ActionController::Base
  include IpBanningConcern
  include HttpBasicAuthentication

  before_action :set_logs

  private

  def set_logs
    @logs = Log.all
  end
end

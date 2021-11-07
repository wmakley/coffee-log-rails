class ApplicationController < ActionController::Base
  include IpBanningConcern
  include HttpBasicAuthentication
end

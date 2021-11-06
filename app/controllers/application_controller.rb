class ApplicationController < ActionController::Base
  include IpBanningConcern
  include HttpBasicAuthentication if Rails.env.production?
end

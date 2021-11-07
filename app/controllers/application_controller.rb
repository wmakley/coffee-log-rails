class ApplicationController < ActionController::Base
  if Rails.env.production?
    include IpBanningConcern
    include HttpBasicAuthentication
  end
end

class ApplicationController < ActionController::Base
  include HttpBasicAuthentication if Rails.env.production?
end

# frozen_string_literal: true

module HttpBasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authenticate

    helper_method :current_user

    mattr_accessor :disable_authentication
  end

  def current_user
    @user
  end

  def http_basic_authenticate
    return if disable_authentication

    authenticate_or_request_with_http_basic do |username, password|
      @user = User.find_by(username: username)
      logger.info "username '#{username}' not found" unless @user

      if @user && @user.password == password
        true
      else
        attempt = Fail2Ban.record_failed_attempt(request.remote_ip)

        Rails.logger.info "Incorrect username or password (#{attempt.attempts} attempts from #{request.remote_ip})"

        false
      end
    end
  end
end

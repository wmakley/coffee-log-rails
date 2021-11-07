# frozen_string_literal: true

module HttpBasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authenticate
  end

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      user = User.find_by(username: username)
      logger.info "username '#{username}' not found" unless user

      success = user && user.password == password

      unless success
        attempt = LoginAttempt.record_attempt(request.remote_ip)

        Rails.logger.info "Incorrect username or password (#{attempt.attempts} attempts from #{request.remote_ip})"

        BannedIp.ban(request.remote_ip) if attempts > 10
      end

      success
    end
  end
end

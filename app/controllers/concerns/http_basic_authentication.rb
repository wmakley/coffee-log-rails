# frozen_string_literal: true

module HttpBasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authenticate

    helper_method :current_user
    helper_method :authenticated?

    mattr_accessor :stub_current_user
  end

  def authenticated?
    !!Current.user
  end

  def current_user
    Current.user
  end

  def http_basic_authenticate
    if stub_current_user
      Current.user = stub_current_user
      return
    end

    authenticate_or_request_with_http_basic do |username, password|
      Current.user = user = User.find_by(username: username)
      logger.info "username '#{username}' not found" unless user

      if user && user.password.present? && user.password == password
        true
      else
        Current.user = nil

        attempt = Fail2Ban.record_failed_attempt(request.remote_ip)

        Rails.logger.info "Incorrect username or password (#{attempt.attempts} attempts from #{request.remote_ip})"

        false
      end
    end
  end
end

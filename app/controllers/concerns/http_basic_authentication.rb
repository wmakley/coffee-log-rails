# frozen_string_literal: true

module HttpBasicAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :http_basic_authenticate

    mattr_accessor :http_basic_users

    self.http_basic_users = ENV['USERS'].split(',')
                                        .map { |u| u.split(':', 2) }
                                        .to_h
  end

  def http_basic_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      success = http_basic_users[username] == password

      unless success
        key = "login-attempts/#{request.remote_ip}"

        attempts = Rails.cache.fetch(key) { 0 }
        attempts += 1

        Rails.cache.write(key, attempts)

        Rails.logger.info "Incorrect username or password (#{attempts} attempts from #{request.remote_ip})"

        ban_ip request.remote_ip if attempts > 10
      end

      success
    end
  end
end

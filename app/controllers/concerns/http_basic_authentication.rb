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
      http_basic_users[username] == password
    end
  end
end

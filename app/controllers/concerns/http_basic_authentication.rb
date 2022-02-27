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

    username = session[:username]

    if username.present?
      password = session[:password]
      last_login_at = Time.at(session[:last_login_at].to_i)

      logger.info "AUTH: Found username #{username} in session, last logged in at #{last_login_at}"

      if last_login_at > 1.month.ago
        Current.user = User.find_by(username: username).authenticate(password)
        if !Current.user
          logger.info "AUTH: Invalid username or password"
          Current.user = nil
          session.delete(:username)
          session.delete(:password)
          session.delete(:last_login_at)
        end
      else
        Current.user = nil
        logger.info "AUTH: Login expired, requiring http basic authentication"
      end
    end

    return true if Current.user

    authenticate_or_request_with_http_basic do |username, password|
      Current.user = user = User.find_by(username: username)
      logger.info "AUTH: username '#{username}' not found" unless user

      if user && user.authenticate(password)
        session[:username] = username
        session[:password] = password
        session[:last_login_at] = Time.now.utc.to_i
        true
      else
        Current.user = nil

        attempt = Fail2Ban.record_failed_attempt(request.remote_ip)

        logger.info "AUTH: Incorrect username or password (#{attempt.attempts} attempts from #{request.remote_ip})"

        false
      end
    end
  end
end

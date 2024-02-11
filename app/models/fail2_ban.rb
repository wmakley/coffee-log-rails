# frozen_string_literal: true
# typed: true

# Singleton fail2ban service module.
class Fail2Ban
  extend T::Sig

  MAX_ATTEMPTS = 10

  class << self
    def instance
      @instance ||= Fail2Ban.new
    end

    delegate :record_failed_attempt, :cleanup_old_attempts, :banned?, :whitelist, to: :instance
  end

  def initialize
    @whitelist = []
  end

  attr_reader :whitelist

  # @param [String] ip_address
  # @return [LoginAttempt,nil]
  sig { params(ip_address: String).returns(LoginAttempt) }
  def record_failed_attempt(ip_address)
    if ip_address.in? whitelist
      Rails.logger.debug "Not recording failed attempt for whitelisted IP #{ip_address}"
      return LoginAttempt.new(ip_address: ip_address, attempts: 1)
    end

    ActiveRecord::Base.transaction do
      attempt = LoginAttempt.record_attempt(ip_address)
      if attempt.attempts >= MAX_ATTEMPTS
        BannedIp.ban(ip_address)
      end
      attempt
    end
  end

  def cleanup_old_attempts
    ActiveRecord::Base.transaction do
      LoginAttempt.remove_old_attempts
      BannedIp.remove_old_bans
    end
  end

  # @param [String] ip_address
  # @return [Boolean]
  sig { params(ip_address: String).returns(T::Boolean) }
  def banned?(ip_address)
    BannedIp.banned?(ip_address)
  end
end

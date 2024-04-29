# frozen_string_literal: true

# Singleton fail2ban service module.
class Fail2Ban
  MAX_ATTEMPTS = 10

  class << self
    def instance
      @instance ||= Fail2Ban.new
    end

    delegate :record_failed_attempt, :cleanup_old_attempts, :banned?, :whitelist, :whitelisted?, to: :instance
  end

  def initialize
    @whitelist = []
  end

  attr_reader :whitelist

  # @param [String] ip_address
  # @return [LoginAttempt,nil]
  def record_failed_attempt(ip_address)
    if ip_address.in? whitelist
      Rails.logger.debug { "Not recording failed attempt for whitelisted IP #{ip_address}" }
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
  def banned?(ip_address)
    BannedIp.banned?(ip_address)
  end

  def whitelisted?(ip_address)
    whitelist.include?(ip_address)
  end
end

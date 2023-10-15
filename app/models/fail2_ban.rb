# frozen_string_literal: true

module Fail2Ban
  MAX_ATTEMPTS = 10

  mattr_accessor :whitelist

  # @param [String] ip_address
  # @return [LoginAttempt,nil]
  def self.record_failed_attempt(ip_address)
    if ip_address.in? whitelist
      Rails.logger.debug "Not recording failed attempt for whitelisted IP #{ip_address}"
      return nil
    end

    ActiveRecord::Base.transaction do
      attempt = LoginAttempt.record_attempt(ip_address)
      if attempt.attempts >= MAX_ATTEMPTS
        BannedIp.ban(ip_address)
      end
      attempt
    end
  end

  def self.cleanup_old_attempts
    ActiveRecord::Base.transaction do
      LoginAttempt.remove_old_attempts
      BannedIp.remove_old_bans
    end
  end

  # @param [String] ip_address
  # @return [Boolean]
  def self.banned?(ip_address)
    BannedIp.banned?(ip_address)
  end
end

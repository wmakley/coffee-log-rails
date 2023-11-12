# frozen_string_literal: true

# Allows locking the account the user is trying unsuccessfully,
# as opposed to just banning their IP address.
module Lockable
  extend ActiveSupport::Concern

  included do
    before_save do
      lock! if remaining_login_attempts <= 0
    end
  end

  MAX_ATTEMPTS = 5
  LOCK_DURATION = 1.hour

  def record_failed_login_attempt!
    self.login_attempts += 1
    save!
  end

  def remaining_login_attempts
    MAX_ATTEMPTS - (login_attempts || 0)
  end

  def lock!
    self.locked_at = Time.now.utc
  end

  def unlock!
    self.login_attempts = 0
    self.locked_at = nil
  end

  def locked?
    return false if locked_at.nil?

    if locked_at <= LOCK_DURATION.ago
      true
    else
      unlock!
      false
    end
  end
end

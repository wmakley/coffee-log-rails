# frozen_string_literal: true

# == Schema Information
#
# Table name: login_attempts
#
#  attempts   :integer          default(1), not null
#  ip_address :string           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class LoginAttempt < ApplicationRecord
  self.primary_key = :ip_address

  validates :ip_address, presence: true
  validates :attempts,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
    }

  MAX_ATTEMPTS = 10

  def self.record_attempt(ip_address)
    attempt = find_or_initialize_by(ip_address: ip_address)
    if attempt.new_record?
      attempt.attempts = 1
    else
      attempt.attempts += 1
    end
    attempt.save!
    attempt
  end

  def self.remove_old_attempts
    where("updated_at < ?", 1.day.ago).delete_all
  end

  def remaining_attempts
    MAX_ATTEMPTS - (attempts || 0)
  end
end

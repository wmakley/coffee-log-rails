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
require "test_helper"

class LoginAttemptTest < ActiveSupport::TestCase
  def valid_attributes
    {
      ip_address: "1.2.3.4",
      attempts: 1,
    }
  end

  test "it saves with valid attributes" do
    attempt = LoginAttempt.new(valid_attributes)
    assert attempt.save
  end

  test "#record_attempt" do
    ip = "1.2.3.4"
    assert_not LoginAttempt.find_by(ip_address: ip)
    record = LoginAttempt.record_attempt(ip)
    assert record.persisted?
    assert_equal 1, record.attempts

    record = LoginAttempt.record_attempt(ip)
    assert_equal 2, record.attempts
  end

  test "#remove_old_attempts" do
    ip = "1.2.3.4"
    record = LoginAttempt.record_attempt(ip)
    record.update!(updated_at: 2.days.ago)
    LoginAttempt.remove_old_attempts

    assert_not LoginAttempt.find_by(ip_address: ip)
  end
end

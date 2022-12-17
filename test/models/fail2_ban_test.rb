# frozen_string_literal: true

require "test_helper"

class Fail2BanTest < ActiveSupport::TestCase
  test "#record_failed_attempt" do
    ip = '1.2.3.4'

    record = Fail2Ban.record_failed_attempt(ip)
    assert record.is_a?(LoginAttempt)
    assert record.persisted?
    assert_equal 1, record.attempts

    record = Fail2Ban.record_failed_attempt(ip)
    assert record.is_a?(LoginAttempt)
    assert_equal 2, record.attempts

    assert_not Fail2Ban.banned?(ip)

    8.times do
      record = Fail2Ban.record_failed_attempt(ip)
    end

    assert_equal 10, record.attempts
    assert Fail2Ban.banned?(ip)
  end
end

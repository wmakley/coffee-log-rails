# frozen_string_literal: true

require "test_helper"

class LogEntryPolicyTest < ActiveSupport::TestCase
  test "can edit own log entry" do
    user = users(:non_admin)
    log = logs(:non_admin)
    entry = log_entries(:non_admin_1)
    policy = LogEntryPolicy.new(entry, user:, log:)

    assert_predicate policy, :update?
  end
end

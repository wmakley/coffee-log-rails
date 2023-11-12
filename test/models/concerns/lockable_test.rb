# frozen_string_literal: true

require 'test_helper'

class LockableTest < ActiveSupport::TestCase
  setup do
    @mock_model = Class.new(ApplicationRecord) do
      self.table_name = "users"
      include Lockable
    end
  end

  test "lockable" do

  end
end

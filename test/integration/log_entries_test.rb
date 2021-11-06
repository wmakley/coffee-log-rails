# frozen_string_literal: true

require 'test_helper'

class LogEntriesTest < ActionDispatch::IntegrationTest
  test "index" do
    get "/logs/default/entries"
    assert_response :success
  end
end

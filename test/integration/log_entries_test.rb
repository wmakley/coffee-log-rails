# frozen_string_literal: true

require 'test_helper'

class LogEntriesTest < ActionDispatch::IntegrationTest
  fixtures :users, :logs, :log_entries

  test "index" do
    get "/logs/default/entries", headers: authorization_header('default', 'password')
    assert_response :success
  end
end

# frozen_string_literal: true

require 'test_helper'

class LogEntriesTest < ActionDispatch::IntegrationTest
  fixtures :users, :logs, :log_entries

  test "index" do
    get "/logs/default/entries", headers: {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials('default', 'password')
    }
    assert_response :success
  end
end

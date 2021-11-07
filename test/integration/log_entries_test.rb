# frozen_string_literal: true

require 'test_helper'

class LogEntriesTest < ActionDispatch::IntegrationTest
  fixtures :users, :logs, :log_entries

  test "index" do
    get "/logs/default/entries", headers: valid_login
    assert_response :success
  end

  test "create success" do
    post "/logs/default/entries",
         params: {
           log_entry: {
             coffee: "Test Coffee"
           }
         },
         headers: valid_login

    assert_redirected_to "/logs/default/entries"
    follow_redirect! headers: valid_login

    assert_response :success

    entry = LogEntry.order(created_at: :desc).first
    assert_select %(a[href="/logs/default/entries/#{entry.id}"]), 1
  end
end

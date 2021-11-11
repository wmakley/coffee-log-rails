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

  test "show" do
    get "/logs/default/entries/1", headers: valid_login
    assert_response :success
  end

  test "edit" do
    get "/logs/default/entries/1/edit", headers: valid_login
    assert_response :success
  end

  test "update success" do
    patch "/logs/default/entries/1",
          params: {
            log_entry: {
              tasting_notes: "Note notes from revelation"
            }
          },
          headers: valid_login

    assert_redirected_to "/logs/default/entries/1"
    follow_redirect! headers: valid_login

    assert_response :success
  end

  test "update failure" do
    patch "/logs/default/entries/1",
          params: {
            log_entry: {
              coffee: ""
            }
          },
          headers: valid_login

    assert_response :unprocessable_entity
  end

  test "destroy success" do
    delete "/logs/default/entries/1", headers: valid_login
    assert_redirected_to "/logs/default/entries"
  end
end

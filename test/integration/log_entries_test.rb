# frozen_string_literal: true

require 'test_helper'

class LogEntriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end

  test "index" do
    get "/logs/default/entries"
    assert_response :success
  end

  test "new" do
    get "/logs/default/entries/new"
    assert_response :success
    assert_select "h1", "New Log Entry"
  end

  test "create success" do
    post "/logs/default/entries",
         params: {
           log_entry: {
             coffee_id: coffees(:one).id,
             entry_date: Time.current.iso8601,
             brew_method_id: brew_methods(:other).id
           }
         }

    assert_redirected_to "/logs/default/entries"
    follow_redirect! headers: valid_login

    assert_response :success

    entry = LogEntry.order(created_at: :desc).first
    assert_select %(a[href="/logs/default/entries/#{entry.id}"]), 1
    assert_select ".alert.alert-success", 1
  end

  test "show" do
    get "/logs/default/entries/1"
    assert_response :success
  end

  test "edit" do
    get "/logs/default/entries/1/edit"
    assert_response :success
  end

  test "update success" do
    patch "/logs/default/entries/1",
          params: {
            log_entry: {
              tasting_notes: "New notes from revelation"
            }
          }

    assert_redirected_to "/logs/default/entries/1"
    follow_redirect!

    assert_response :success
    assert_select ".alert.alert-success", 1
  end

  test "update failure" do
    patch "/logs/default/entries/1",
          params: {
            log_entry: {
              coffee_id: ""
            }
          }

    assert_response :unprocessable_entity
  end

  test "destroy success" do
    delete "/logs/default/entries/1"
    assert_redirected_to "/logs/default/entries"
    follow_redirect!
    assert_select ".alert.alert-success", 1
  end
end

# frozen_string_literal: true

require 'test_helper'

class AuthenticationTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "http basic authentication" do
    get "/logs/default/entries", headers: valid_login
    assert_response :success
  end

  test "session authentication" do
    s = open_session
    s.get "/logs/default/entries", headers: valid_login
    s.assert_response :success

    assert_equal "default", s.session[:username]
    assert s.session[:last_login_at] <= Time.current.to_i

    s.get "/logs/default/entries"
    s.assert_response :success
  end
end

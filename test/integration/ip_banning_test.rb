# frozen_string_literal: true

require 'test_helper'

class IpBanningTest < ActionDispatch::IntegrationTest
  # fixtures :logs, :users

  test "IPs are banned after 10 failed login attempts" do
    assert_not Fail2Ban.banned?('127.0.0.1')

    invalid_params = {
      login_form: {
        username: random_string(16),
        password: random_string(16)
      }
    }

    Fail2Ban::MAX_ATTEMPTS.times do |n|
      post "/session", params: invalid_params
      assert_response :unprocessable_entity, "#{n}th iteration"
    end

    post "/session", params: invalid_params
    assert_response :not_found

    assert Fail2Ban.banned?('127.0.0.1')
  end

  test "IPs are banned after 10 failed password reset requests" do
    assert_not Fail2Ban.banned?('127.0.0.1')

    invalid_params = {
      password_reset_request: {
        email: "test@asdfasdfasf.com",
      }
    }

    Fail2Ban::MAX_ATTEMPTS.times do |n|
      post "/password_reset_request", params: invalid_params
      assert_redirected_to "/", "#{n}th iteration"
    end

    post "/password_reset_request", params: invalid_params
    assert_response :not_found

    assert Fail2Ban.banned?('127.0.0.1')
  end

  test "IPs are banned after 10 failed password reset attempts" do
    assert_not Fail2Ban.banned?('127.0.0.1')

    invalid_params = {
      password_reset: {
        token: '1234',
        password: 'asdfasdf',
        password_confirmation: 'asdfasdf'
      }
    }

    Fail2Ban::MAX_ATTEMPTS.times do |n|
      patch "/password", params: invalid_params
      assert_response :unprocessable_entity, "#{n}th iteration"
    end

    patch "/password", params: invalid_params
    assert_response :not_found

    assert Fail2Ban.banned?('127.0.0.1')
  end
end

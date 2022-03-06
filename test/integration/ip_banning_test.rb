# frozen_string_literal: true

require 'test_helper'

class IpBanningTest < ActionDispatch::IntegrationTest
  fixtures :logs

  test "IPs are banned after 10 failed attempts" do
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
end

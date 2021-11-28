# frozen_string_literal: true

require 'test_helper'

class IpBanningTest < ActionDispatch::IntegrationTest
  fixtures :logs

  setup do
    enable_authentication
  end

  test "ips are banned after 10 bad guesses" do
    headers = authorization_header('asdf', 'asdf')

    1.upto(Fail2Ban::MAX_ATTEMPTS) do
      get "/logs/default/entries", headers: headers
      assert_response 401
    end

    get "/logs/default/entries", headers: headers
    assert_response :not_found
  end
end

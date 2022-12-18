# frozen_string_literal: true

require 'test_helper'

class BannedIpsTest < ActionDispatch::IntegrationTest
  # fixtures :users, :banned_ips, :login_attempts

  test "admin may view index" do
    login_as users(:admin)
    get "/banned_ips"
    assert_response :success
  end

  test "non-admin may not view index" do
    login_as users(:non_admin)
    get "/banned_ips"
    assert_redirected_to "/"
  end

  test "admin may un-ban IP" do
    login_as users(:admin)
    ip = banned_ips(:one_two_three)
    delete "/banned_ips/#{ip.to_param}"
    assert_redirected_to "/banned_ips"
    follow_redirect!
    assert_select ".alert-success", "Successfuly un-banned IP address."
  end

  test "non-admin may not un-ban IP" do
    login_as users(:non_admin)
    ip = banned_ips(:one_two_three)
    delete "/banned_ips/#{ip.to_param}"
    assert_redirected_to "/"
    follow_redirect!
    # assert_select ".alert-danger", "Not authorized"
  end
end

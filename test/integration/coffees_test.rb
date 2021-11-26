# frozen_string_literal: true

require "test_helper"

class CoffeesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "index" do
    get "/coffees", headers: valid_login
    assert_response :success
  end

  test "new" do
    get "/coffees/new", headers: valid_login
    assert_response :success
  end
end

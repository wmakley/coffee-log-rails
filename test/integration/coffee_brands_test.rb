# frozen_string_literal: true

require "test_helper"

class CoffeeBrandsTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "index" do
    get "/coffee_brands", headers: valid_login
    assert_response :success
  end
end

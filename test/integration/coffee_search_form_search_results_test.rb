# frozen_string_literal: true

require "test_helper"

class CoffeeSearchFormSearchResultsTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end

  test "no query returns no results" do
    get "/coffee_search_form/search_results", params: {
      query: "",
      format: :turbo_stream
    }

    assert_response :success
  end
end

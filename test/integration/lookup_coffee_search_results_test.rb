# frozen_string_literal: true

require "test_helper"

class LookupCoffeeSearchResultsTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end

  test "no query returns no results" do
    get "/lookup_coffee/search_results", params: {
      query: "",
      format: :turbo_stream
    }

    assert_response :success
  end
end

# frozen_string_literal: true

require "test_helper"

class CoffeesTest < ActionDispatch::IntegrationTest
  test "index" do
    login_as users(:non_admin)
    get "/coffees"
    assert_response :success
    assert_select ".card-title", coffees(:one).name
  end

  test "show" do
    login_as users(:non_admin)
    get "/coffees/1"
    assert_response :success
    assert_select "h1", coffees(:one).name
  end

  test "new" do
    login_as users(:non_admin)
    get "/coffees/new"
    assert_response :success
    assert_select "form"
  end

  test "create success" do
    login_as users(:non_admin)
    post "/coffees",
      params: {
        coffee: {
          name: "New Test Coffee",
        },
      }
    coffee = Coffee.last
    assert_redirected_to "/coffees/#{coffee.id}"
    follow_redirect!
    assert_response :success
  end

  test "create failure" do
    login_as users(:non_admin)
    post "/coffees",
      params: {
        coffee: {
          name: "",
        },
      }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "update success" do
    login_as users(:non_admin)
    patch "/coffees/1",
      params: {
        coffee: {
          name: "New Test Coffee",
        },
      }
    assert_redirected_to "/coffees/1"
    follow_redirect!
    assert_response :success
  end

  test "update failure" do
    login_as users(:non_admin)
    patch "/coffees/1",
      params: {
        coffee: {
          name: "",
        },
      }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "destroy as non-admin is not authorized" do
    login_as users(:non_admin)
    coffee = coffees(:no_entries)
    delete "/coffees/#{coffee.id}"
    assert_not_authorized
  end

  test "destroy as admin success" do
    login_as users(:admin)
    coffee = coffees(:no_entries)
    delete "/coffees/#{coffee.id}"
    assert_redirected_to "/coffees"
    follow_redirect!
    assert_notice "Successfully deleted coffee."
  end

  test "destroy as admin failure" do
    login_as users(:admin)
    coffee = coffees(:one)
    delete "/coffees/#{coffee.id}"
    assert_redirected_to "/coffees"
    follow_redirect!
    assert_error "Cannot delete record because dependent log entries exist."
  end
end

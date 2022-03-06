# frozen_string_literal: true

require "test_helper"

class CoffeesTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end

  test "index" do
    get "/coffees"
    assert_response :success
    assert_select ".card-title", coffees(:one).name
  end

  test "show" do
    get "/coffees/1"
    assert_response :success
    assert_select "h1", coffees(:one).name
  end

  test "new" do
    get "/coffees/new"
    assert_response :success
    assert_select "form"
  end

  test "create success" do
    post "/coffees",
         params: {
           coffee: {
             name: "New Test Coffee"
           }
         }
    coffee = Coffee.last
    assert_redirected_to "/coffees/#{coffee.id}"
    follow_redirect!
    assert_response :success
  end

  test "create failure" do
    post "/coffees",
         params: {
           coffee: {
             name: ""
           }
         }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "update success" do
    patch "/coffees/1",
         params: {
           coffee: {
             name: "New Test Coffee"
           }
         }
    assert_redirected_to "/coffees/1"
    follow_redirect!
    assert_response :success
  end

  test "update failure" do
    patch "/coffees/1",
         params: {
           coffee: {
             name: ""
           }
         }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "destroy success" do
    coffee = coffees(:no_entries)
    delete "/coffees/#{coffee.id}"
    assert_redirected_to "/coffees"
    follow_redirect!
    assert_notice "Successfully deleted coffee."
  end

  test "destroy failure" do
    coffee = coffees(:one)
    delete "/coffees/#{coffee.id}"
    assert_redirected_to "/coffees"
    follow_redirect!
    assert_error "Cannot delete record because dependent log entries exist."
  end
end

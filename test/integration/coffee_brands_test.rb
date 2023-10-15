# frozen_string_literal: true

require "test_helper"

class CoffeeBrandsTest < ActionDispatch::IntegrationTest

  test "index" do
    login_as users(:non_admin)
    get "/coffee_brands"
    assert_response :success
    assert_select "h1", "Coffee Brands"
  end

  test "show" do
    login_as users(:non_admin)
    get "/coffee_brands/1"
    assert_response :success
    assert_select "h1", coffee_brands(:one).name
  end

  test "new" do
    login_as users(:non_admin)
    get "/coffee_brands/new"
    assert_response :success
    assert_select "h1", "New Coffee Brand"
  end

  test "create success" do
    login_as users(:non_admin)
    post "/coffee_brands",
         params: {
           coffee_brand: {
             name: "Test Brand"
           }
         }
    brand = CoffeeBrand.last
    assert_redirected_to "/coffee_brands/#{brand.id}"
    follow_redirect!
    assert_response :success
  end

  test "create failure" do
    login_as users(:non_admin)
    post "/coffee_brands",
         params: {
           coffee_brand: {
             name: ""
           }
         }
    assert_response :unprocessable_entity
  end

  test "edit" do
    login_as users(:non_admin)
    get "/coffee_brands/1/edit"
    assert_response :success
  end

  test "update success" do
    login_as users(:non_admin)
    patch "/coffee_brands/1",
          params: {
            coffee_brand: {
              name: "New Name"
            }
          }
    assert_redirected_to "/coffee_brands/1"
    follow_redirect!
    assert_response :success
  end

  test "update failure" do
    login_as users(:non_admin)
    patch "/coffee_brands/1",
          params: {
            coffee_brand: {
              name: ""
            }
          }
    assert_response :unprocessable_entity
  end

  test "destroy as non_admin is not authorized" do ||
    login_as users(:non_admin)
    coffee_brand = CoffeeBrand.create!(name: random_string(8))
    delete "/coffee_brands/#{coffee_brand.to_param}"
    assert_not_authorized
  end

  test "destroy as admin success" do
    login_as users(:admin)
    coffee_brand = CoffeeBrand.create!(name: random_string(8))
    delete "/coffee_brands/#{coffee_brand.to_param}"
    assert_redirected_to "/coffee_brands"
    follow_redirect!
    assert_notice "Successfully deleted coffee brand."
  end

  test "destroy as admin failure" do
    login_as users(:admin)
    coffee_brand = coffee_brands(:default)
    delete "/coffee_brands/#{coffee_brand.to_param}"
    assert_redirected_to "/coffee_brands"
    follow_redirect!
    assert_error "May not delete default brand."
  end
end

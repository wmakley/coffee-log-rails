# frozen_string_literal: true

require "test_helper"

class CoffeeBrandsTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end

  test "index" do
    get "/coffee_brands"
    assert_response :success
    assert_select "h1", "Coffee Brands"
  end

  test "show" do
    get "/coffee_brands/1"
    assert_response :success
    assert_select "h1", coffee_brands(:one).name
  end

  test "new" do
    get "/coffee_brands/new"
    assert_response :success
    assert_select "h1", "New Coffee Brand"
  end

  test "create success" do
    post "/coffee_brands",
         params: {
           coffee_brand: {
             name: "Test Brand"
           }
         },
         headers: valid_login
    brand = CoffeeBrand.last
    assert_redirected_to "/coffee_brands/#{brand.id}"
    follow_redirect!
    assert_response :success
  end

  test "create failure" do
    post "/coffee_brands",
         params: {
           coffee_brand: {
             name: ""
           }
         }
    assert_response :unprocessable_entity
  end

  test "edit" do
    get "/coffee_brands/1/edit"
    assert_response :success
  end

  test "update success" do
    patch "/coffee_brands/1",
          params: {
            coffee_brand: {
              name: "New Name"
            }
          },
          headers: valid_login
    assert_redirected_to "/coffee_brands/1"
    follow_redirect!
    assert_response :success
  end

  test "update failure" do
    patch "/coffee_brands/1",
          params: {
            coffee_brand: {
              name: ""
            }
          }
    assert_response :unprocessable_entity
  end

  test "destroy success" do
    coffee_brand = CoffeeBrand.create!(name: random_string(8))
    delete "/coffee_brands/#{coffee_brand.to_param}"
    assert_redirected_to "/coffee_brands"
    follow_redirect!
    assert_notice "Successfully deleted coffee brand."
  end

  test "destroy failure" do
    coffee_brand = coffee_brands(:default)
    delete "/coffee_brands/#{coffee_brand.to_param}"
    assert_redirected_to "/coffee_brands"
    follow_redirect!
    assert_error "May not delete default brand."
  end
end

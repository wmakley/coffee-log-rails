# frozen_string_literal: true

require 'test_helper'

class BrewMethodsTest < ActionDispatch::IntegrationTest


  setup do
    login_as users(:admin)
  end

  test "GET index" do
    get "/brew_methods"
    assert_response :success
    assert_select "h1", "Brew Methods"
  end

  test "GET show" do
    get "/brew_methods/1"
    assert_response :success
    assert_select "h1", "Pour-Over"
  end

  test "GET new" do
    get "/brew_methods/new"
    assert_response :success
    assert_select "h1", "New Brew Method"
    assert_select "form"
  end

  test "POST create success" do
    post "/brew_methods", params: {
      brew_method: {
        name: "Test New Method",
        default_brew_ratio: "18",
      }
    }
    assert_redirected_to "/brew_methods"
    follow_redirect!
    assert_select ".alert.alert-success"
  end

  test "create failure" do
    post "/brew_methods", params: {
      brew_method: {
        name: "",
        default_brew_ratio: "",
      }
    }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "edit" do
    get "/brew_methods/1/edit"
    assert_response :success
    assert_select "h1", "Edit Brew Method"
  end

  test "update success" do
    patch "/brew_methods/1", params: {
      brew_method: {
        name: "New Pour-Over",
        default_brew_ratio: "12",
      }
    }
    assert_redirected_to "/brew_methods"
    follow_redirect!
    assert_select ".alert-success", "Successfully updated brew method."
  end

  test "update failure" do
    patch "/brew_methods/1", params: {
      brew_method: {
        name: "",
        default_brew_ratio: "",
      }
    }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  test "destroy success" do
    delete "/brew_methods/2"
    assert_redirected_to "/brew_methods"
    follow_redirect!
    assert_select ".alert-success", "Successfully deleted brew method."
  end
end

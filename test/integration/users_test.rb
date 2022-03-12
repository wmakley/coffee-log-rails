# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "not accessible by non-admin" do
    login_as :non_admin
    get "/users"
    assert_redirected_to "/"
  end

  test "accessible by admin" do
    login_as :admin
    get "/users"
    assert_response :success
    assert_select "table.table"
  end

  test "new user" do
    login_as :admin
    get "/users/new"
    assert_response :success
    assert_select "form"
  end

  test "create user success" do
    login_as :admin
    post "/users", params: {
      user: {
        display_name: "Test",
        username: "test",
        email: random_email,
        password: "testtesttest",
      }
    }
    assert_redirected_to "/users"
    follow_redirect!
    assert_response :success
    assert_select ".alert.alert-success", 1
  end

  test "edit user" do
    login_as :admin
    get "/users/1/edit"
    assert_response :success
  end

  test "update user success" do
    login_as :admin
    patch "/users/1", params: {
      user: {
        display_name: "New Name",
      }
    }
    assert_redirected_to "/users"
    follow_redirect!
    assert_response :success
    assert_select ".alert.alert-success", 1
  end

  test "update user failure" do
    login_as :admin
    patch "/users/1", params: {
      user: {
        display_name: "",
      }
    }
    assert_response :unprocessable_entity
  end
end

require "test_helper"

class UserGroupsTest < ActionDispatch::IntegrationTest
  test "admins may view" do
    login_as users(:admin)
    get "/user-groups"
    assert_response :success
  end

  test "non-admins are denied" do
    login_as users(:non_admin)
    get "/user-groups"
    assert_not_authorized
  end

  test "can view new" do
    login_as users(:admin)
    get "/user-groups/new"
    assert_response :success
    assert_select "form.user-group", 1
  end

  test "create with valid attributes" do
    login_as users(:admin)
    post "/user-groups", params: {
      user_group: valid_attributes,
    }
    assert_redirected_to "/user-groups"
    assert_equal "Successfully created user group.", flash[:notice]
  end

  test "create with invalid attributes" do
    login_as users(:admin)
    post "/user-groups", params: {
      user_group: invalid_attributes,
    }
    assert_response :unprocessable_entity
    assert_select "form.user-group", 1
  end

  test "can edit" do
    login_as users(:admin)
    get "/user-groups/#{user_groups(:default).to_param}/edit"
    assert_response :success
    assert_select "form.user-group", 1
  end

  test "update with valid atttributes" do
    login_as users(:admin)
    user_group = UserGroup.create!(valid_attributes)
    patch "/user-groups/#{user_group.to_param}", params: {
      user_group: {
        name: "new name",
      },
    }
    assert_redirected_to "/user-groups"
    assert_equal "Successfully updated user group.", flash[:notice]
    user_group.reload
    assert_equal "new name", user_group.name
  end

  test "update with invalid attributes" do
    login_as users(:admin)
    user_group = UserGroup.create!(valid_attributes)
    patch "/user-groups/#{user_group.to_param}", params: {
      user_group: {
        name: "",
      },
    }
    assert_response :unprocessable_entity
    assert_select "form.user-group", 1
  end

  test "destroy success" do
    login_as users(:admin)
    user_group = UserGroup.create!(valid_attributes)
    initial_count = UserGroup.count
    assert_changes -> { UserGroup.count }, from: initial_count, to: initial_count - 1 do
      delete "/user-groups/#{user_group.to_param}"
    end
    assert_redirected_to "/user-groups"
    assert_equal "Successfully deleted user group.", flash[:notice]
  end

  def valid_attributes
    {
      name: random_string(8),
    }
  end

  def invalid_attributes
    {
      name: "",
    }
  end
end

require "test_helper"

class UserGroupMembershipsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:admin)
    @user_group = user_groups(:default)
  end

  test "index" do
    get "/user-groups/#{@user_group.to_param}/memberships"
    assert_response :success
  end

  test "get new" do
    get "/user-groups/#{@user_group.to_param}/memberships/new"
    assert_response :success
    assert_select "form.group-membership", 1
  end

  test "create with valid attributes" do
    user = users(:group_a)
    post "/user-groups/#{@user_group.to_param}/memberships", params: {
      group_membership: {
        user_id: user.id,
      },
    }
    assert_redirected_to "/user-groups/#{@user_group.to_param}/memberships"
    assert_equal "Successfully added user to group.", flash[:notice]
  end

  test "create with invalid attributes" do
    post "/user-groups/#{@user_group.to_param}/memberships", params: {
      group_membership: {
        user_id: nil,
      },
    }
    assert_response :unprocessable_entity
    assert_select "form.group-membership", 1
  end
end

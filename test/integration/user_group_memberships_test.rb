require 'test_helper'

class UserGroupMembershipsTest < ActionDispatch::IntegrationTest
  setup do
    login_as users(:admin)
    @user_group = user_groups(:default)
  end

  test "index" do
    get "/user-groups/#{@user_group.to_param}/memberships"
    assert_response :success
  end
end

# frozen_string_literal: true

class UserGroupMembershipsController < InternalController
  before_action :set_user_group

  def index
    authorize! GroupMembership
    @group_memberships = @user_group.group_memberships.includes(:user).order(:id)
  end

  def new
    authorize! GroupMembership
    @group_membership = GroupMembership.new
  end

  def create
    authorize! GroupMembership
    @group_membership = GroupMembership.new(group_membership_params)
    @group_membership.user_group = @user_group

    if @group_membership.save
      redirect_to user_group_memberships_url(@user_group), notice: "Successfully added user to group."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  private

    def set_user_group
      @user_group = UserGroup.find(params[:user_group_id])
    end

    def group_membership_params
      params.require(:group_membership).permit(:user_id)
    end
end

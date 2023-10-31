# frozen_string_literal: true

class UserGroupsController < InternalController
  before_action :set_user_group, only: [:show, :edit, :update, :destroy]

  def index
    authorize!
    @user_groups = UserGroup.by_name
  end

  def show
    raise NotImplementedError
  end

  def new
    authorize!
    @user_group = UserGroup.new
  end

  def create
    authorize!
    @user_group = UserGroup.new(user_group_params)

    if @user_group.save
      redirect_to user_groups_url, notice: "Successfully created user group."
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! @user_group
  end

  def update
    authorize! @user_group
    if @user_group.update(user_group_params)
      redirect_to user_groups_url, notice: "Successfully updated user group."
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @user_group
    respond_to do |format|
      if @user_group.destroy
        format.html { redirect_to user_groups_url, status: :see_other, notice: "Successfully deleted user group." }
        format.turbo_stream
      else
        format.html { redirect_to user_groups_url, error: "#{@user_group.errors.full_messages.to_sentence}." }
        format.turbo_stream
      end
    end
  end

  private

  def set_user_group
    @user_group = UserGroup.find(params[:id])
  end

  def user_group_params
    params.require(:user_group).permit(
      :name,
    )
  end
end

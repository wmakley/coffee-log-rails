# frozen_string_literal: true

class UsersController < ApplicationController
  include AdminRequired

  def index
    @users = User.all.by_name
  end

  def show
    raise "not implemented"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "Succesfully created user." }
      else
        format.html { render action: :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: "Succesfully updated user." }
      else
        format.html { render action: :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_url, status: :see_other, notice: "Successfully deleted user." }
        format.turbo_stream
      else
        format.html { redirect_to users_url, error: "#{@user.errors.full_messages.to_sentence}." }
        format.turbo_stream
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(
        :display_name,
        :email,
        :username,
        :password,
        :password_confirmation,
        :admin,
      )
    end
end

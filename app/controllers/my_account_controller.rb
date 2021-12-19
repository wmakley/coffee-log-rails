# frozen_string_literal: true

class MyAccountController < ApplicationController
  def show
    @my_account = Current.user
  end

  def edit
    redirect_to action: :show
  end

  def update
    @my_account = Current.user

    if @my_account.update(my_account_params)
      redirect_to my_account_url, notice: "Successfully updated account."
    else
      render action: :show, status: :unprocessable_entity
    end
  end

  private

    def my_account_params
      params.require(:user).permit(
        :display_name,
        :email,
        :username,
        :password
      )
    end
end

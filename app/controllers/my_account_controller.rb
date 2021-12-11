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

    if @my_account.update(params.require(:user).permit(:display_name, :username, :password))
      redirect_to my_account_url, notice: "Succesfully updated account."
    else
      redirect_to my_account_url, error: @my_account.errors.full_messages.to_sentence + "."
    end
  end
end

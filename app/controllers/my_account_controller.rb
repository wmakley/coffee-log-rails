# frozen_string_literal: true

class MyAccountController < InternalController
  before_action :authorize!

  def show
    @my_account = MyAccount.new
  end

  def update
    @my_account = MyAccount.new

    if @my_account.update(my_account_params)
      redirect_to my_account_url, status: :see_other, notice: "Successfully updated account."
    else
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  def my_account_params
    params.require(:my_account).permit(
      :display_name,
      :email,
      :password,
      :password_confirmation,
    ).with_defaults(
      password_confirmation: "",
    )
  end
end

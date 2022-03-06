# frozen_string_literal: true

class PasswordResetRequestMailer < ApplicationMailer
  def reset_password_link
    @user = params[:user]
    mail(to: @user.email, subject: "Reset Coffee Log Password")
  end
end

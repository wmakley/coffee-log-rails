class SignupFormMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    mail(to: @user.email, subject: "Thank You For Signing Up to Coffee Log!")
  end
end

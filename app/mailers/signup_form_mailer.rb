# frozen_string_literal: true
# typed: true

class SignupFormMailer < ApplicationMailer
  sig { returns(Mail::Message) }
  def welcome_email
    @user = params[:user]
    mail(to: @user.new_email, subject: "Thank You For Signing Up to Coffee Log!")
  end
end

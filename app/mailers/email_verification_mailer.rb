# frozen_string_literal: true

class EmailVerificationMailer < ApplicationMailer
  def verification_link
    @user = params[:user]

    if @user.email_verification_token.blank?
      raise ArgumentError, "user does not have an email_verification_token"
    end

    mail(to: @user.email, subject: "Verify Your Coffee Log Email")
  end
end

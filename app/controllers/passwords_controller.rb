# frozen_string_literal: true

class PasswordsController < ApplicationController
  layout "sessions"

  skip_before_action :authenticate_user_from_session!

  def index
    redirect_to action: :edit
  end

  def show
    redirect_to action: :edit
  end

  def edit
    if params[:token].blank?
      return redirect_to root_url, error: "Invalid password reset token."
    end

    @password_reset = PasswordReset.new(token: params[:token].to_s)
  end

  def update
    @password_reset = PasswordReset.new(password_reset_params)

    if @password_reset.save
      reset_session
      redirect_to new_session_url, notice: "Successfully reset password. Please login with your new password."
    else
      reset_session
      render action: :edit, status: :unprocessable_entity
    end

    Fail2Ban.record_failed_attempt(request.remote_ip) if @password_reset.invalid_token?
  end

  private

    def password_reset_params
      params.require(:password_reset).permit(
        :token,
        :password,
        :password_confirmation
      ).to_h
    end
end

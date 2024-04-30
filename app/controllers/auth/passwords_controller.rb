# frozen_string_literal: true

module Auth
  class PasswordsController < ExternalController
    def index
      redirect_to action: :edit
    end

    def show
      redirect_to action: :edit
    end

    def edit
      if params[:token].blank?
        return redirect_to root_url, status: :see_other, error: "Invalid password reset token."
      end

      @password_reset = PasswordReset.new(token: params[:token].to_s)
    end

    def update
      @password_reset = PasswordReset.new(password_reset_params)

      reset_session
      delete_authentication_cookie

      if @password_reset.save
        redirect_to new_auth_session_url, status: :see_other, notice: "Successfully reset password. Please login with your new password."
      else
        render action: :edit, status: :unprocessable_entity
      end

      Fail2Ban.record_failed_attempt(request.remote_ip) if @password_reset.invalid_token?
    end

    private

    def password_reset_params
      params.require(:password_reset).permit(
        :token,
        :password,
        :password_confirmation,
      ).with_defaults(
        password_confirmation: "",
      ).to_h
    end
  end
end

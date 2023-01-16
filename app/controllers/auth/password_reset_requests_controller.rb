# frozen_string_literal: true

module Auth
  class PasswordResetRequestsController < ExternalController

    def index
      redirect_to action: :new
    end

    def show
      redirect_to action: :new
    end

    def new
      @password_reset_request = PasswordResetRequest.new
    end

    def create
      @password_reset_request = PasswordResetRequest.new(password_reset_request_params)
      if @password_reset_request.save
        redirect_to root_url, notice: "A reset link has been sent to your email address."
      else
        render action: :new, status: :unprocessable_entity
      end

      Fail2Ban.record_failed_attempt(request.remote_ip) if @password_reset_request.invalid_email?
    end

    private

      def password_reset_request_params
        params.require(:password_reset_request).permit(:email)
      end
  end
end

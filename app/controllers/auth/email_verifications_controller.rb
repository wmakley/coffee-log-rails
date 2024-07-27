# frozen_string_literal: true

module Auth
  class EmailVerificationsController < ExternalController
    before_action :soft_authenticate_user_from_session
    before_action :redirect_to_app, if: -> { authenticated? && !current_user.needs_email_verification? }

    def show
      redirect_to action: :new, status: :see_other
    end

    def new
      @email_verification_form = EmailVerificationForm.new(email_verification_params)
    end

    def create
      @email_verification_form ||= EmailVerificationForm.new(email_verification_params)

      if @email_verification_form.save
        flash[:notice] = "Your email has been successfully verified!"
        if authenticated?
          redirect_to_app
        else
          redirect_to_login
        end
      else
        render action: :new, status: :unprocessable_entity
      end
    end

    private

    def email_verification_params
      params.permit(:email, :token, :submit_immediately)
    end
  end
end

# frozen_string_literal: true

module Auth
  class EmailVerificationsController < ExternalController
    def show
      redirect_to action: :new
    end

    alias index show

    def new
      @email_verification_form = EmailVerificationForm.new(email_verification_params)
    end

    def create

    end

    private

      def email_verification_params
        params.permit(:email, :token)
      end
  end
end

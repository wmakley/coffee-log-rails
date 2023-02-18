# frozen_string_literal: true

module Auth
  class EmailVerificationsController < ExternalController

    def show
      redirect_to action: :new, status: :see_other
    end

    def index
      redirect_to action: :new, status: :see_other
    end

    def new
      @email_verification_form = EmailVerificationForm.new(email_verification_params)

      # Automatically try to validate email if form is valid
      # (user clicked link in their email to make a GET request)
      if @email_verification_form.valid?
        create
      else
        # don't show the form full of red ink before user has filled it out
        @email_verification_form.errors.clear
      end
    end

    def create
      @email_verification_form ||= EmailVerificationForm.new(email_verification_params)

      if @email_verification_form.save
        redirect_to root_url, status: :see_other
      else
        render action: :new, status: :unprocessable_entity
      end
    end

    private

      def email_verification_params
        params.permit(:email, :token)
      end
  end
end

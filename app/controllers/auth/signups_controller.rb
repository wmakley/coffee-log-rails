# frozen_string_literal: true

module Auth
  class SignupsController < ExternalController
    def show
      redirect_to action: :new
    end

    alias index show

    def new
      @signup = ::SignupForm.new
    end

    def create
      @signup = ::SignupForm.new(signup_form_params)

      if @signup.save
        flash[:notice] = "Your account has been created!"
        redirect_to success_auth_signup_path
      else
        if @signup.invalid_code?
          attempt = Fail2Ban.record_failed_attempt(request.remote_ip)
          flash[:error] = "#{attempt.remaining_attempts} #{'attempt'.pluralize(attempt.remaining_attempts)} remaining."
        end
        logger.error "Error Saving form: #{@signup.errors.full_messages.inspect}"
        render action: :new, status: :unprocessable_entity
      end
    end

    def success
    end

    private

      def signup_form_params
        params.require(:signup_form).permit(
          :code,
          :email,
          :display_name,
          :password,
          :password_confirmation,
        )
      end
  end
end

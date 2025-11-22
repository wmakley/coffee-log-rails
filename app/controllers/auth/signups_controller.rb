module Auth
  class SignupsController < ExternalController
    def show
      redirect_to action: :new
    end

    alias_method :index, :show

    def new
      @signup = ::UserSignup.new
    end

    def create
      @signup = ::UserSignup.new(user_signup_params)

      if @signup.invalid?
        return render action: :new, status: :unprocessable_content
      end

      verify_captcha(action: "signup").on_failure do
        flash.now[:error] = "ReCAPTCHA verification failed, please refresh the page and try again."
        return render action: :new, status: :unprocessable_content
      end

      unless @signup.save
        if @signup.invalid_code?
          attempt = Fail2Ban.record_failed_attempt(request.remote_ip)
          flash[:error] = "#{attempt.remaining_attempts} #{"attempt".pluralize(attempt.remaining_attempts)} remaining."
        end
        logger.error "Error Saving form: #{@signup.errors.full_messages.inspect}"
        return render action: :new, status: :unprocessable_content
      end

      user = @signup.user
      flash[:notice] = "Your account has been created!"
      begin
        authenticate_user_from_form(
          LoginForm.new(
            username: user.username,
            password: @signup.password,
          ),
        )
      rescue EmailVerificationNeededError
        # expected
      end

      redirect_to success_auth_signup_path, status: :see_other
    end

    def success
    end

    private

    def user_signup_params
      params.require(:user_signup).permit(
        :code,
        :new_email,
        :display_name,
        :password,
        :password_confirmation,
      )
    end
  end
end

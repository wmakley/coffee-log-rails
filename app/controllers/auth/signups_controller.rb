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

      success = verify_recaptcha(action: "login", minimum_score: 0.5)
      logger.info "Recaptcha success: #{success}"
      if !success
        logger.warn "Recaptcha reply is nil" if recaptcha_reply.nil?
        score = recaptcha_reply["score"] if recaptcha_reply
        logger.info("User was denied signup because of a recaptcha score of #{score.inspect} | reply: #{recaptcha_reply.inspect}")
      end

      if success && (user = @signup.save)
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
        redirect_to success_auth_signup_path
      else
        @signup.errors.add(:base, "ReCAPTCHA verification failed") unless success
        if @signup.invalid_code? || !success
          attempt = Fail2Ban.record_failed_attempt(request.remote_ip)
          flash[:error] = "#{attempt.remaining_attempts} #{"attempt".pluralize(attempt.remaining_attempts)} remaining."
        end
        logger.error "Error Saving form: #{@signup.errors.full_messages.inspect}"
        render action: :new, status: :unprocessable_entity
      end
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

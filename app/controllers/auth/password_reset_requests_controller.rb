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
      success = verify_recaptcha(action: 'request_password_reset', minimum_score: 0.5)
      logger.info "Recaptcha success: #{success}"
      if !success
        logger.warn "Recaptcha reply is nil" if recaptcha_reply.nil?
        score = recaptcha_reply['score'] if recaptcha_reply
        logger.warn("User was denied login because of a recaptcha score of #{score.inspect} | reply: #{recaptcha_reply.inspect}")
      end

      @password_reset_request = PasswordResetRequest.new(password_reset_request_params)
      if success && @password_reset_request.save
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

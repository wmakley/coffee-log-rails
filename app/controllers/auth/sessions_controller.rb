# frozen_string_literal: true

module Auth
  class SessionsController < ExternalController
    before_action :soft_authenticate_user_from_session, only: [:index, :show, :new]
    before_action :redirect_to_app, if: :authenticated?

    def index
      redirect_to new_auth_session_url, status: :see_other
    end

    def show
      redirect_to new_auth_session_url, status: :see_other
    end

    def new
      @login_form = LoginForm.new
    end

    def create
      @login_form = LoginForm.new(login_form_params)
      return_to = session[:return_to]
      if authenticate_user_from_form(@login_form)
        url = return_to.presence || logs_url
        redirect_to url, status: :see_other
      else
        flash[:error] = "Username or password not correct."
        Fail2Ban.record_failed_attempt(request.remote_ip) if @login_form.valid?
        render action: :new, status: :unprocessable_entity
      end
    rescue EmailVerificationNeededError => ex
      ex.user.generate_new_verification_token_and_send_email!
      raise ex
    end

    def destroy
      logout_current_user
      redirect_to new_auth_session_url, status: :see_other
    end

    private

      def login_form_params
        params.require(:login_form).permit(:username, :password)
      end
  end
end

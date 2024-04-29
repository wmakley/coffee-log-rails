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

      # missing required fields
      if @login_form.invalid?
        return render action: :new, status: :unprocessable_entity
      end

      # captcha
      verify_captcha(action: "login").on_failure do
        flash.now[:error] = "ReCAPTCHA verification failed, please refresh the page and try again."
        return render action: :new, status: :unprocessable_entity
      end

      # username / password failure
      unless authenticate_user_from_form(@login_form)
        flash.now[:error] = "Username or password not correct."
        Fail2Ban.record_failed_attempt(request.remote_ip) if @login_form.valid?
        return render action: :new, status: :unprocessable_entity
      end

      # success
      respond_to do |format|
        url = session[:return_to].presence || logs_url
        flash[:notice] = "Successfully logged in!"

        format.turbo_stream do
          render turbo_stream: turbo_stream.action(:redirect, url)
        end
        format.html do
          redirect_to url, status: :see_other
        end
      end
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

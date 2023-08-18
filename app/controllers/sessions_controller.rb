# frozen_string_literal: true

class SessionsController < ApplicationController
  include Recaptcha::Adapters::ControllerMethods

  layout "sessions"

  skip_before_action :authenticate_user_from_session!
  before_action :soft_authenticate_user_from_session, only: [:index, :show, :new]
  before_action :redirect_to_app, if: :authenticated?

  def index
    redirect_to new_session_url, status: :see_other
  end

  def show
    redirect_to new_session_url, status: :see_other
  end

  def new
    @login_form = LoginForm.new
  end

  def create
    success = Rails.env.test? || verify_recaptcha(action: 'login', minimum_score: 0.5)

    @login_form = LoginForm.new(login_form_params)
    return_to = session[:return_to]
    if success && authenticate_user_from_form(@login_form)
      url = return_to.presence || logs_url
      redirect_to url, status: :see_other
    else
      flash[:error] = "Username or password not correct."
      Fail2Ban.record_failed_attempt(request.remote_ip) if @login_form.valid?
      render action: :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout_current_user
    redirect_to new_session_url, status: :see_other
  end

  private

    def login_form_params
      params.require(:login_form).permit(:username, :password)
    end

    def redirect_to_app
      redirect_to logs_url, status: :see_other
    end
end

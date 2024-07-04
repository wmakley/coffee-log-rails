# frozen_string_literal: true

module Auth
  class ExternalController < ::ApplicationController
    protect_from_forgery with: :exception
    layout "sessions"

    rescue_from ActionController::InvalidAuthenticityToken do
      flash[:error] = "Your session expired, please try again."
      redirect_back_or_to root_path, status: :see_other
    end
  end
end

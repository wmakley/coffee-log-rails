# frozen_string_literal: true

class InternalController < ApplicationController
  before_action :authenticate_user_from_session!
  # before_action :set_paper_trail_whodunnit
  before_action :set_logs
  verify_authorized

  rescue_from ActionPolicy::Unauthorized do |exception|
    respond_to do |format|
      format.html do
        msg = I18n.t('errors.not_authorized')
        flash[:error] = msg
        redirect_back_or_to root_path
      end
    end
  end

  private

    def set_logs
      @logs = Log.visible_to_user(Current.user)
    end
end

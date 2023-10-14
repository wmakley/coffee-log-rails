# frozen_string_literal: true

class InternalController < ApplicationController
  before_action :authenticate_user_from_session!
  # before_action :set_paper_trail_whodunnit
  before_action :set_logs

  private

    def set_logs
      @logs = Log.visible_to_user(Current.user)
    end
end

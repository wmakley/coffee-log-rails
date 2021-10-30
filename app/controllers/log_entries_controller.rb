# frozen_string_literal: true

class LogEntriesController < ApplicationController
  before_action :set_log

  def index

  end

  private

    def set_log
      @log = Log.find_by!(slug: params[:log_id])
    end
end

# frozen_string_literal: true

class LogsController < ApplicationController
  def index
    redirect_to log_entries_url('default')
  end
end

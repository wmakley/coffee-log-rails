# frozen_string_literal: true

class LogsController < ApplicationController
  def index
    create_or_redirect_to_log_for_user
  end

  def create_or_redirect_to_log_for_user
    log = Log.owned_by_user(current_user).first

    if log.nil?
      logger.info "Log for user '#{current_user.username}' not found, creating"
      log = Log.create!(
        owned_by_user: current_user,
        name: current_user.username.capitalize,
        slug: current_user.username.downcase.gsub(/[^a-z0-9\-_]/, '-')
      )
    end

    redirect_to log_entries_url(log)
  end
end

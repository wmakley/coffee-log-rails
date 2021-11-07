# frozen_string_literal: true

class LogsController < ApplicationController
  def index
    create_or_redirect_to_log_for_user
  end

  def create_or_redirect_to_log_for_user
    slug = current_user.username.downcase

    log = Log.where(slug: slug).first
    if log.nil?
      logger.info "Log for user '#{current_user.username}' not found, creating"
      log = Log.create!(
        name: current_user.username.capitalize,
        slug: slug
      )
    end

    redirect_to log_entries_url(log)
  end
end

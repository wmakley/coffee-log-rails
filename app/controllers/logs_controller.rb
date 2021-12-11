# frozen_string_literal: true

class LogsController < ApplicationController
  def index
    create_or_redirect_to_log_for_user
  end

  def show
    redirect_to log_entries_url(params[:id])
  end

  def create_or_redirect_to_log_for_user
    log = Log.user(current_user).first

    if log.nil?
      logger.info "Log for user '#{current_user.username}' not found, creating"
      log = Log.create!(
        user: current_user,
        title: "#{current_user.display_name}'s Log",
        slug: current_user.username.downcase.gsub(/[^a-z0-9\-_]/, '-')
      )
    end

    redirect_to log_entries_url(log)
  end

  def destroy
    @log = Log.find_by_slug(params[:id])

    unless Current.user.admin?
      return redirect_to log_entries_url(@log), error: "Only admins may delete logs."
    end

    unless @log.destroy
      return redirect_to log_entries_url(@log), error: "#{@log.errors.full_messages.to_sentence}."
    end

    redirect_to logs_url, notice: "Successfully deleted log and all entries."
  end
end

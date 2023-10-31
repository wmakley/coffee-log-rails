class LogsController < InternalController
  skip_verify_authorized only: [:index]

  def index
    create_or_redirect_to_log_for_user
  end

  def show
    redirect_to log_entries_url(params[:id])
  end

  def destroy
    @log = authorized_scope(Log.all).find_by_slug(params[:id])

    unless Current.user.admin?
      return redirect_to log_entries_url(@log), error: "Only admins may delete logs."
    end

    unless @log.destroy
      return redirect_to log_entries_url(@log), error: "#{@log.errors.full_messages.to_sentence}."
    end

    redirect_to logs_url, notice: "Successfully deleted log and all entries."
  end

  private

  def create_or_redirect_to_log_for_user
    log = Log.owner(current_user).order(:id).first

    if log.nil?
      logger.info "Log for user '#{current_user.username}' not found, creating"
      log = Log.create!(
        user: current_user,
        title: "#{current_user.display_name}'s Log",
        slug: current_user.short_username.gsub(/[^a-z0-9\-_]/, "-"),
      )
    end

    redirect_to log_entries_url(log)
  end
end

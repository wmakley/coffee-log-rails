# frozen_string_literal: true

class LogEntriesController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_log
  before_action :set_log_entry, only: [:show, :edit, :update, :destroy]

  def index
    @log_entries = @log.log_entries.by_date_desc.load
    set_new_log_entry_from_previous(@log_entries.first)
  end

  def show
  end

  def new
    @log_entry = LogEntry.new(log: @log)
  end

  def create
    @log_entry = LogEntry.new(log: @log)

    respond_to do |format|
      if @log_entry.update(log_entry_params)
        format.html { redirect_to log_entries_url(@log), notice: "Created log entry" }
        format.turbo_stream do
          set_new_log_entry_from_previous(@log_entry)
        end
      else
        format.html { render action: :new, status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit
  end

  def update
    if @log_entry.update(log_entry_params)
      redirect_to log_entry_url(@log, @log_entry), notice: "Updated log entry"
    else
      render action: :edit
    end
  end

  def destroy
    @log_entry.mark_as_deleted!

    respond_to do |format|
      format.html { redirect_to log_entries_url(@log), status: :see_other, notice: "Deleted log entry" }
      # format.turbo_stream { redirect_to log_entries_url(@log), notice: "Deleted log entry" }
    end
  end

  private

    def log_entry_params
      params.require(:log_entry)
            .permit(
              :coffee,
              :water,
              :brew_method,
              :grind,
              :tasting,
              :addl_notes,
              :coffee_grams,
              :water_grams,
              :created_at
            )
    end

    def set_log
      @log = Log.find_by!(slug: params[:log_id])
    end

    def set_log_entry
      @log_entry = @log.log_entries.find(params[:id])
    end

    def set_new_log_entry_from_previous(most_recent_entry = nil)
      @new_log_entry = LogEntry.new(log: @log)
      if most_recent_entry
        @new_log_entry.attributes = {
          coffee: most_recent_entry.coffee,
          water: most_recent_entry.water,
          brew_method: most_recent_entry.brew_method,
          grind: most_recent_entry.grind,
          coffee_grams: most_recent_entry.coffee_grams,
          water_grams: most_recent_entry.water_grams,
        }
      end
    end
end

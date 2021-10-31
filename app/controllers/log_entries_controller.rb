# frozen_string_literal: true

class LogEntriesController < ApplicationController
  before_action :set_log
  before_action :set_log_entry, only: [:show, :edit, :update, :destroy]

  def index
    @log_entries = @log.log_entries.by_date_desc.load

    @new_log_entry = LogEntry.new(log: @log)
    if (most_recent_entry = @log_entries.first)
      @new_log_entry.attributes = {
        coffee: most_recent_entry.coffee,
        water: most_recent_entry.water,
        method: most_recent_entry.method,
        grind: most_recent_entry.grind,
        coffee_grams: most_recent_entry.coffee_grams,
        water_grams: most_recent_entry.water_grams,
      }
    end
  end

  def show
  end

  def new
    @log_entry = LogEntry.new(log: @log)
  end

  def create
    @log_entry = LogEntry.new(log_entry_params)

    if @log_entry.save
      redirect_to log_entries_url(@log), notice: "Updated log entry"
    else
      render action: :new
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
    redirect_to log_entries_url(@log), notice: "Deleted log entry"
  end

  private

    def log_entry_params
      params.require(:log_entry)
            .permit(
              :coffee,
              :water,
              :method,
              :grind,
              :tasting,
              :addl_notes,
              :coffee_grams,
              :water_grams
            )
    end

    def set_log
      @log = Log.find_by!(slug: params[:log_id])
    end

    def set_log_entry
      @log_entry = @log.log_entries.find(params[:id])
    end
end

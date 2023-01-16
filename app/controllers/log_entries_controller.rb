# frozen_string_literal: true

class LogEntriesController < InternalController
  include ActionView::RecordIdentifier

  before_action :set_log
  before_action :set_log_entry, only: [:show, :edit, :update, :destroy]

  def index
    @log_entries = @log.log_entries.by_date_desc.includes(
      coffee: { photo_attachment: :blob },
      brew_method: {}
    ).load

    set_new_log_entry_from_previous(@log_entries.first)
    set_brew_methods
  end

  def show
  end

  def new
    @log_entry = LogEntry.new(log: @log, entry_date: Time.current)
    @log_entry.attributes = params.permit(:coffee_id)
    set_brew_methods
  end

  def create
    @log_entry = LogEntry.new(log: @log)
    @log_entry.attributes = log_entry_params
    @log_entry.entry_date ||= Time.current

    respond_to do |format|
      if @log_entry.save
        format.html do
          redirect_to log_entries_url(@log), notice: "Successfully created log entry."
        end
        format.turbo_stream do
          set_brew_methods
          set_new_log_entry_from_previous(@log_entry)
        end
      else
        logger.debug "Log Entry Validation Errors: #{@log_entry.errors.full_messages.inspect}"
        format.html do
          set_brew_methods
          render action: :new, status: :unprocessable_entity
        end
        format.turbo_stream do
          set_brew_methods
        end
      end
    end
  end

  def edit
    set_brew_methods
  end

  def update
    if @log_entry.update(log_entry_params)
      redirect_to log_entry_url(@log, @log_entry), notice: "Updated log entry"
    else
      set_brew_methods
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    respond_to do |format|
      if @log_entry.destroy
        format.html { redirect_to log_entries_url(@log), status: :see_other, notice: "Deleted log entry" }
        # format.turbo_stream { redirect_to log_entries_url(@log), notice: "Deleted log entry" }
      else
        format.html { redirect_to log_entry_url(@log, @log_entry), error: "#{@log_entry.errors.full_messages.to_sentence}." }
      end
    end
  end

  private

    def log_entry_params
      params.require(:log_entry)
            .permit(
              :entry_date,
              :coffee_id,
              :water,
              :brew_method_id,
              :grind_notes,
              :grind_setting,
              :preparation_notes,
              :tasting_notes,
              :addl_notes,
              :coffee_grams,
              :water_grams,
              :water_temp_in_celsius,
              :water_temp_in_fahrenheit,
              :bitterness,
              :acidity,
              :body,
              :strength,
              :overall_rating,
            )
    end

    def set_log
      @log = Log.find_by!(slug: params[:log_id])
    end

    def set_log_entry
      @log_entry = @log.log_entries.find(params[:id])
    end

    def set_new_log_entry_from_previous(most_recent_entry)
      @new_log_entry = LogEntry.new(log: @log, entry_date: Time.current)

      if most_recent_entry
        @new_log_entry.attributes = {
          coffee_id: most_recent_entry.coffee_id,
          water: most_recent_entry.water,
          brew_method_id: most_recent_entry.brew_method_id,
          grind_notes: most_recent_entry.grind_notes,
          grind_setting: most_recent_entry.grind_setting,
          coffee_grams: most_recent_entry.coffee_grams,
          water_grams: most_recent_entry.water_grams,
          preparation_notes: most_recent_entry.preparation_notes,
          water_temp_in_celsius: most_recent_entry.water_temp_in_celsius,
        }
      end

      if params[:coffee_id].present?
        @new_log_entry.coffee_id = params[:coffee_id].to_s
      end
    end

    def set_brew_methods
      @brew_methods = BrewMethod.for_select
    end
end

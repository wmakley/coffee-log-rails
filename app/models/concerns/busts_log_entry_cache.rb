# frozen_string_literal: true

# If a record has_many :log_entries and is included in any cached log entry views,
# then those log entries and logs should be invalidated when the record is saved.
module BustsLogEntryCache
  extend ActiveSupport::Concern

  included do
    after_save :touch_log_entries, if: :saved_changes?
  end

  def touch_log_entries
    log_entry_scope = busts_log_entry_cache_log_entry_scope
    log_entry_scope.update_all(updated_at: updated_at)
    Log.touch_by_log_entry_scope(log_entry_scope, updated_at)
  end

  # Override to change the scope that is used to touch log entries and associated logs on save.
  # Defaults to #log_entries.
  def busts_log_entry_cache_log_entry_scope
    log_entries
  end
end

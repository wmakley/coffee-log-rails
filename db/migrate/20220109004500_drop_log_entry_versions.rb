class DropLogEntryVersions < ActiveRecord::Migration[7.0]
  def change
    drop_table :log_entry_versions
  end
end

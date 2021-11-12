class AddEntryDateToLogEntries < ActiveRecord::Migration[6.1]
  def up
    add_column :log_entries, :entry_date, :timestamp

    execute "update log_entries set entry_date = created_at"

    change_column_null :log_entries, :entry_date, false

    remove_index :log_entries, [:log_id, :created_at], where: "deleted_at is not null"
    add_index :log_entries, [:log_id, :entry_date], where: "deleted_at is not null"
  end

  def down
    remove_index :log_entries, [:log_id, :entry_date], where: "deleted_at is not null"
    remove_column :log_entries, :entry_date
    add_index :log_entries, [:log_id, :created_at], where: "deleted_at is not null"
  end
end

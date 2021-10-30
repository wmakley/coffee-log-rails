class AddMostRecentLogEntriesIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :log_entries, [:log_id, :created_at], where: "deleted_at is not null"
  end
end

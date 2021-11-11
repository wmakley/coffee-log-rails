class FixBadNames < ActiveRecord::Migration[6.1]
  def up
    remove_foreign_key :logs, :users, column: :owned_by_user_id
    remove_index :logs, :owned_by_user_id

    rename_column :logs, :owned_by_user_id, :user_id

    add_index :logs, :user_id
    add_foreign_key :logs, :users, column: :user_id

    rename_column :users, :name, :display_name
    rename_column :log_entries, :grind, :grind_notes
    rename_column :log_entries, :tasting, :tasting_notes

    rename_column :log_entry_versions, :grind, :grind_notes
    rename_column :log_entry_versions, :tasting, :tasting_notes
  end

  def down
    remove_foreign_key :logs, :users, column: :user_id
    remove_index :logs, :user_id

    rename_column :logs, :user_id, :owned_by_user_id

    add_index :logs, :owned_by_user_id
    add_foreign_key :logs, :users, column: :owned_by_user_id

    rename_column :users, :display_name, :name
    rename_column :log_entries, :grind_notes, :grind
    rename_column :log_entries, :tasting_notes, :tasting

    rename_column :log_entry_versions, :grind_notes, :grind
    rename_column :log_entry_versions, :tasting_notes, :tasting
  end
end

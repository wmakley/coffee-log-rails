class RenameMethodToBrewMethod < ActiveRecord::Migration[6.1]
  def change
    rename_column :log_entries, :method, :brew_method
    rename_column :log_entry_versions, :method, :brew_method
  end
end

class AddIndexToLogsSlug < ActiveRecord::Migration[6.1]
  def change
    add_index :logs, :slug, unique: true
  end
end

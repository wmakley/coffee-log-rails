class RenameLogsNameToTitle < ActiveRecord::Migration[6.1]
  def change
    rename_column :logs, :name, :title
  end
end

class AddNumericalFieldsToLogEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :log_entries, :water_temp_in_celsius, :float
    add_column :log_entries, :grind_setting, :float
  end
end

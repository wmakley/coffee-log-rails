class CreateLogEntryVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :log_entry_versions do |t|
      t.references :log_entry, null: false, foreign_key: true
      t.string :coffee
      t.string :water
      t.string :method
      t.string :grind
      t.text :tasting
      t.text :addl_notes
      t.integer :coffee_grams
      t.integer :water_grams

      t.timestamp :deleted_at
      t.timestamps
    end
  end
end

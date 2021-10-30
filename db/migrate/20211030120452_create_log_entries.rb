class CreateLogEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :log_entries do |t|
      t.references :log, null: false, foreign_key: true
      t.string :coffee, null: false
      t.string :water
      t.string :method
      t.string :grind
      t.string :tasting
      t.text :addl_notes
      t.integer :coffee_grams
      t.integer :water_grams

      t.timestamps
    end
  end
end

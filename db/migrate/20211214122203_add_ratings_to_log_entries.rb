class AddRatingsToLogEntries < ActiveRecord::Migration[6.1]
  def change
    change_table :log_entries do |t|
      t.text :preparation_notes

      t.integer :bitterness
      t.integer :acidity
      t.integer :body
      t.integer :strength
      t.integer :overall_rating
    end
  end
end

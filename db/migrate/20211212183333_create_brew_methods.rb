class CreateBrewMethods < ActiveRecord::Migration[6.1]
  class BrewMethod < ActiveRecord::Base
  end

  class LogEntry < ActiveRecord::Base
  end

  def up
    create_table :brew_methods do |t|
      t.string :name, null: false, unique: true
      t.float :default_brew_ratio, null: false, default: 16.6667

      t.timestamps
    end

    add_column :log_entries, :brew_method_id, :bigint
    add_foreign_key :log_entries, :brew_methods

    # ["French Press", "Pour-Over", "Moka Pot", "Drip", "Cup", "Other"]
    brew_methods = BrewMethod.create!(
      [ { name: "French Press" },
        { name: "Pour-Over" },
        { name: "Moka Pot" },
        { name: "Drip" },
        { name: "Cup" },
        { id: 0, name: "Other" },
      ]
    )
    pp brew_methods

    LogEntry.find_each do |log_entry|
      brew_method_id = brew_methods.find {|bm| bm.name == log_entry.brew_method}.id
      log_entry.update_column(:brew_method_id, brew_method_id)
    end

    change_column_null :log_entries, :brew_method_id, false
    add_index :log_entries, :brew_method_id
    remove_column :log_entries, :brew_method
  end
end

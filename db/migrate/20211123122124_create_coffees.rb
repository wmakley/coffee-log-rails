# frozen_string_literal: true

# Normalize coffees
class CreateCoffees < ActiveRecord::Migration[6.1]
  class LogEntry < ActiveRecord::Base
  end

  class Coffee < ActiveRecord::Base
  end

  def up
    create_table :coffees do |t|
      t.references :coffee_brand, null: false, foreign_key: true, default: 0
      t.string :name, null: false
      t.string :roast
      t.text :notes

      t.timestamps
    end

    add_index :coffees, [:coffee_brand_id, :name], unique: true

    # Normalize log entry coffees
    add_column :log_entries, :coffee_id, :bigint

    coffee_names = LogEntry.all.pluck(Arel.sql("distinct coffee"))
    coffee_names.each do |coffee_name|
      puts "Creating coffee: #{coffee_name}"
      coffee = Coffee.create!(name: coffee_name, coffee_brand_id: 0)
      LogEntry.where(coffee: coffee_name).update_all(coffee_id: coffee.id)
    end

    add_index :log_entries, :coffee_id

    change_column_null :log_entries, :coffee_id, false
    add_foreign_key :log_entries, :coffees,
      column: :coffee_id,
      on_update: :cascade,
      on_delete: :restrict
    remove_column :log_entries, :coffee

    add_column :log_entry_versions, :coffee_id, :bigint
    add_foreign_key :log_entry_versions, :coffees,
      column: :coffee_id,
      on_update: :cascade,
      on_delete: :restrict
    execute "UPDATE log_entry_versions SET coffee_id = (SELECT e.coffee_id FROM log_entries e WHERE e.id = log_entry_versions.log_entry_id)"
    change_column_null :log_entry_versions, :coffee_id, false
    remove_column :log_entry_versions, :coffee
  end

  def down
    # de-normalize the data again
    add_column :log_entries, :coffee, :string
    execute "UPDATE log_entries SET coffee = (select c.name from coffees c where c.id = log_entries.coffee_id)"
    change_column_null :log_entries, :coffee, false
    remove_column :log_entries, :coffee_id

    add_column :log_entry_versions, :coffee, :string
    execute "UPDATE log_entry_versions SET coffee = (select c.name from coffees c where c.id = log_entry_versions.coffee_id)"
    change_column_null :log_entry_versions, :coffee, false
    remove_column :log_entry_versions, :coffee_id

    drop_table :coffees
  end
end

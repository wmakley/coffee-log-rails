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

    coffee_names = LogEntry.pluck(Arel.sql("distinct coffee"))
    coffee_names.each do |coffee_name|
      puts "Creating coffee: #{coffee_name}"
      coffee = Coffee.create!(name: coffee_name, coffee_brand_id: 0)
      LogEntry.where(coffee: coffee_name).update_all(coffee_id: coffee.id)
    end

    add_index :log_entries, :coffee_id

    if LogEntry.where(coffee_id: nil).exists?
      raise "not all coffee_id foreign keys were set"
    end

    change_column_null :log_entries, :coffee_id, false
    add_foreign_key :log_entries, :coffees, column: :coffee_id
    remove_column :log_entries, :coffee
  end

  def down
    add_column :log_entries, :coffee, :string

    execute "UPDATE log_entries SET coffee = (select c.name from coffees c where c.id = log_entries.coffee_id)"

    change_column_null :log_entries, :coffee, false

    remove_column :log_entries, :coffee_id

    drop_table :coffees
  end
end

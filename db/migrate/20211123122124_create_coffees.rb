class CreateCoffees < ActiveRecord::Migration[6.1]
  def change
    create_table :coffees do |t|
      t.references :coffee_brand, null: true, foreign_key: true
      t.string :name, null: false
      t.string :roast
      t.text :notes

      t.timestamps
    end

    add_index :coffees, [:coffee_brand_id, :name], unique: true
  end
end

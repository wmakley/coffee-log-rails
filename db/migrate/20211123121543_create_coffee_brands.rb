class CreateCoffeeBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :coffee_brands do |t|
      t.string :name, null: false
      t.string :url

      t.timestamps
    end

    add_index :coffee_brands, :name, unique: true
  end
end

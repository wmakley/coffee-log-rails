class CreateCoffeeBrands < ActiveRecord::Migration[6.1]
  class CoffeeBrand < ActiveRecord::Base
  end

  def up
    create_table :coffee_brands do |t|
      t.string :name, null: false
      t.string :url

      t.timestamps
    end

    add_index :coffee_brands, :name, unique: true

    default_brand = CoffeeBrand.new(
      id: 0,
      name: "Unknown"
    )
    puts "Creating default brand: #{default_brand.inspect}"
    default_brand.save!
  end

  def down
    remove_index :coffee_brands, :name
    drop_table :coffee_brands
  end
end

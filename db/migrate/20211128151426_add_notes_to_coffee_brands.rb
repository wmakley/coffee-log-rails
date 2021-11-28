class AddNotesToCoffeeBrands < ActiveRecord::Migration[6.1]
  def change
    add_column :coffee_brands, :notes, :text
  end
end

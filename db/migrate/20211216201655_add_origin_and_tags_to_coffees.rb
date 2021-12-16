class AddOriginAndTagsToCoffees < ActiveRecord::Migration[6.1]
  def change
    add_column :coffees, :origin, :string
    add_column :coffees, :decaf, :boolean
    add_column :coffees, :process, :string
  end
end

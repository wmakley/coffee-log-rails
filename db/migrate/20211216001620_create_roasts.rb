class CreateRoasts < ActiveRecord::Migration[6.1]
  class Roast < ActiveRecord::Base
  end

  class Coffee < ActiveRecord::Base
  end

  def up
    create_table :roasts do |t|
      t.string :name, null: false
      t.text :notes
      t.timestamps
      t.index :name, unique: true
    end

    roasts = Roast.create!([
                             { id: 1, name: "Light" },
                             { id: 2, name: "Medium-Light" },
                             { id: 3, name: "Medium" },
                             { id: 4, name: "Medium-Dark" },
                             { id: 5, name: "Dark" }
                           ])
    pp roasts

    add_column :coffees, :roast_id, :bigint
    add_index :coffees, :roast_id
    add_foreign_key :coffees, :roasts, column: :roast_id

    Coffee.where("roast is not null").each do |coffee|
      roast = roasts.find { |r| r.name == coffee.roast }
      puts "Set #{coffee.name} roast to #{roast.inspect}"
      coffee.update_column(:roast_id, roast.id)
    end

    remove_column :coffees, :roast
  end
end

class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :user_groups, :name, unique: true
  end
end

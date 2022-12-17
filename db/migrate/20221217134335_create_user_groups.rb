class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups do |t|
      t.string :name, null: false
      # null codes may not be signed up
      t.string :signup_code

      t.timestamps
    end

    add_index :user_groups, :name, unique: true
    add_index :user_groups, :signup_code, unique: true
  end
end

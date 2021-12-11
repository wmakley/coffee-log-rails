class AddAdminAndPreferencesToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :preferences, :jsonb, null: false, default: '{}'

    execute "UPDATE users SET admin = 1 WHERE id = 1"
  end

  def down
    remove_column :users, :preferences
    remove_column :users, :admin
  end
end

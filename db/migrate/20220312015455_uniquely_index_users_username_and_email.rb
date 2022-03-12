class UniquelyIndexUsersUsernameAndEmail < ActiveRecord::Migration[7.0]
  def up
    add_index :users, :email, unique: true, where: "email IS NOT NULL"
    remove_index :users, :username
    add_index :users, :username, unique: true
  end

  def down
    remove_index :users, :email
    remove_index :users, :username
    add_index :users, :username
  end
end

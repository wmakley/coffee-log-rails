class AddNewEmailToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :new_email, :citext
    add_index :users, :new_email, unique: true, where: "new_email IS NOT NULL"
  end
end

class AddUserLockouts < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_attempts, :integer, null: false, default: 0
    add_column :users, :locked_at, :timestamp
  end
end

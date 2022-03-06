class AddPasswordChangedAtAndForgotPasswordTokenToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :password_changed_at, :timestamp
    execute "UPDATE users SET password_changed_at = updated_at WHERE password_changed_at IS NULL"
    change_column_null :users, :password_changed_at, false

    add_column :users, :forgot_password_token, :string
    add_column :users, :forgot_password_token_token_created_at, :timestamp
  end

  def down
    remove_column :users, :forgot_password_token_token_created_at
    remove_column :users, :forgot_password_token
    remove_column :users, :password_changed_at
  end
end

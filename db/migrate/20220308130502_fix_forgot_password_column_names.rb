class FixForgotPasswordColumnNames < ActiveRecord::Migration[7.0]
  def up
    rename_column :users, :forgot_password_token, :reset_password_token
    rename_column :users, :forgot_password_token_token_created_at, :reset_password_token_created_at
  end

  def down
    rename_column :users, :reset_password_token, :forgot_password_token
    rename_column :users, :reset_password_token_created_at, :forgot_password_token_token_created_at
  end
end

class AddUniqueIndexToResetPasswordTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :reset_password_token, unique: true, where: "reset_password_token IS NOT NULL"
  end
end

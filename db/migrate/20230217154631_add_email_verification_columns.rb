class AddEmailVerificationColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :email_verification_token
      t.timestamp :email_verified_at
      t.index :email_verification_token, unique: true, where: "email_verification_token IS NOT NULL"
    end
  end
end

class AddActivationCodeAndActivationCodeAtToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :activation_code
      t.timestamp :activation_code_at

      t.index :activation_code, unique: true
    end
  end
end

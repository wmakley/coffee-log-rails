class RemoveActivationCodeFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :activation_code
    remove_column :users, :activation_code_at
  end

  def down
    change_table :users do |t|
      t.string :activation_code
      t.timestamp :activation_code_at

      t.index :activation_code, unique: true
    end
  end
end

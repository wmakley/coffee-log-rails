class CreateSignupCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :signup_codes do |t|
      t.references :user_group, null: false, foreign_key: true
      t.string :code, null: false
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    add_index :signup_codes, :code, unique: true
  end
end

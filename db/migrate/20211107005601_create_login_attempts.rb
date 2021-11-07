# frozen_string_literal: true

class CreateLoginAttempts < ActiveRecord::Migration[6.1]
  def change
    create_table :login_attempts, id: false do |t|
      t.string :ip_address, null: false, primary_key: true
      t.integer :attempts, null: false, default: 1
      t.timestamps
    end
  end
end

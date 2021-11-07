# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true, unique: true
      t.string :password, null: false
      t.timestamps
    end
  end
end

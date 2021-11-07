# frozen_string_literal: true

class AddOwnedByUserIdToLogs < ActiveRecord::Migration[6.1]
  def up
    add_column :logs, :owned_by_user_id, :bigint

    execute "update logs set owned_by_user_id = (select id from users where username = logs.slug)"
    execute "delete from logs where owned_by_user_id is null"

    add_index :logs, :owned_by_user_id
    add_foreign_key :logs, :users, column: :owned_by_user_id
    change_column_null :logs, :owned_by_user_id, false
  end

  def down
    remove_column :logs, :owned_by_user_id
  end
end

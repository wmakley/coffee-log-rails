class AddAdminAndPreferencesToUsers < ActiveRecord::Migration[6.1]
  class User < ActiveRecord::Base
  end

  def up
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :preferences, :jsonb, null: false, default: '{}'

    default_admin = User.where(id: 1)
    if default_admin
      default_admin.update(admin: true)
    end
  end

  def down
    remove_column :users, :preferences
    remove_column :users, :admin
  end
end

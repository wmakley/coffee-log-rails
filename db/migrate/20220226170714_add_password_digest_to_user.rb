class AddPasswordDigestToUser < ActiveRecord::Migration[7.0]
  class User < ActiveRecord::Base
    has_secure_password
  end

  def up
    rename_column :users, :password, :old_password
    add_column :users, :password_digest, :string

    User.find_each do |user|
      user.password = user.old_password
      user.save!
    end

    remove_column :users, :old_password
  end
end

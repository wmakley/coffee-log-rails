class AddNameToUsers < ActiveRecord::Migration[6.1]
  class User < ActiveRecord::Base
  end

  def change
    add_column :users, :name, :string

    User.find_each do |u|
      u.name = u.username.capitalize
      u.save!
    end
  end
end

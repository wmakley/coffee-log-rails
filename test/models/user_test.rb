# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  name       :string
#  password   :string           not null
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase
  test "it saves with valid attributes" do
    user = User.new(username: "fu", password: "bar", name: "Fred")
    assert user.save
  end
end

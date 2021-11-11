# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  display_name :string
#  password     :string           not null
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase
  def valid_attributes
    {
      username: "fu",
      password: "bar",
      display_name: "Fred"
    }
  end

  test "it saves with valid attributes" do
    user = User.new(valid_attributes)
    assert user.save
  end
end

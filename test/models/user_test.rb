# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  admin        :boolean          default(FALSE), not null
#  display_name :string
#  email        :string
#  password     :string           not null
#  preferences  :jsonb            not null
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
      username: random_string(8),
      password: "testtesttest",
      display_name: random_string(8),
    }
  end

  test "it saves with valid attributes" do
    user = User.new(valid_attributes)
    assert user.save, "error saving user: #{user.errors.full_messages.inspect}"
  end

  test "password validation" do
    user = User.new(valid_attributes)
    assert user.valid?, "user should have been valid: #{user.errors.full_messages.inspect}"

    user.password = " testtesttest"
    assert_not user.valid?, "password may not begin with whitespace"

    user.password = "testtesttest "
    assert_not user.valid?, "password may not end with whitespace"

    user.password = "testtest testtest"
    assert user.valid?, "password may contain whitespace"
  end
end

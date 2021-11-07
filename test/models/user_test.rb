require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase
  test "it saves with valid attributes" do
    user = User.new(username: "fu", password: "bar")
    assert user.save
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                     :bigint           not null, primary key
#  admin                                  :boolean          default(FALSE), not null
#  display_name                           :string
#  email                                  :string
#  forgot_password_token                  :string
#  forgot_password_token_token_created_at :datetime
#  password_changed_at                    :datetime         not null
#  password_digest                        :string
#  preferences                            :jsonb            not null
#  username                               :string           not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def valid_attributes
    {
      username: random_string(8),
      password: "testtesttest",
      password_confirmation: "testtesttest",
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
    user.password_confirmation = " testtesttest"
    assert_not user.valid?, "password may not begin with whitespace"

    user.password = "testtesttest "
    user.password_confirmation = "testtesttest "
    assert_not user.valid?, "password may not end with whitespace"

    user.password = "testtest testtest"
    user.password_confirmation = "testtest testtest"
    assert user.valid?, "password may contain whitespace"
  end

  test "password changed at" do
    user = User.create!(valid_attributes)
    ts1 = user.password_changed_at
    assert_not_nil ts1

    user.password = random_string(16)
    user.password_confirmation = user.password
    user.save!
    ts2 = user.password_changed_at
    assert_not_nil ts2
    assert ts2 > ts1
  end
end

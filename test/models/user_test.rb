# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  activation_code                 :string
#  activation_code_at              :datetime
#  admin                           :boolean          default(FALSE), not null
#  display_name                    :string
#  email                           :citext
#  email_verification_token        :string
#  email_verified_at               :datetime
#  last_login_at                   :datetime
#  password_changed_at             :datetime         not null
#  password_digest                 :string
#  preferences                     :jsonb            not null
#  reset_password_token            :string
#  reset_password_token_created_at :datetime
#  username                        :string           not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
# Indexes
#
#  index_users_on_activation_code           (activation_code) UNIQUE
#  index_users_on_email                     (email) UNIQUE WHERE (email IS NOT NULL)
#  index_users_on_email_verification_token  (email_verification_token) UNIQUE WHERE (email_verification_token IS NOT NULL)
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE WHERE (reset_password_token IS NOT NULL)
#  index_users_on_username                  (username) UNIQUE
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def valid_attributes
    {
      username: random_string(8),
      email: random_email,
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

  test "emails are not case-sensitive" do
    email = "test@#{random_string(8)}.com"
    user = User.create!(valid_attributes.merge(email: email))

    user2 = User.new(valid_attributes.merge(email: email.upcase))
    assert_not user2.valid?
    assert_not_nil user2.errors[:email]

    assert_equal user, User.find_by(email: email.upcase)
  end
end

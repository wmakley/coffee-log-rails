# == Schema Information
#
# Table name: signup_codes
#
#  id            :bigint           not null, primary key
#  active        :boolean          default(FALSE), not null
#  code          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_group_id :bigint           not null
#
# Indexes
#
#  index_signup_codes_on_code           (code) UNIQUE
#  index_signup_codes_on_user_group_id  (user_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_group_id => user_groups.id)
#
require "test_helper"

class SignupCodeTest < ActiveSupport::TestCase

  def valid_attributes
    with_unique_number do |n|
      {
        user_group_id: user_groups(:default).id,
        code: "TEST#{n}",
      }
    end
  end

  test "it saves with valid attributes" do
    assert SignupCode.new(valid_attributes).save!
  end
end

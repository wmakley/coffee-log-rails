# == Schema Information
#
# Table name: user_groups
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_groups_on_name  (name) UNIQUE
#
require "test_helper"

class UserGroupTest < ActiveSupport::TestCase

  def valid_attributes
    with_unique_number do |n|
      {
        name: "Test Group #{n}"
      }
    end
  end

  test "it saves with valid attributes" do
    assert UserGroup.new(valid_attributes).save!
  end
end

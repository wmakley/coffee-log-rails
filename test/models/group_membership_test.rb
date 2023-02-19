# == Schema Information
#
# Table name: group_memberships
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_group_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_group_memberships_on_user_group_id  (user_group_id)
#  index_group_memberships_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_group_id => user_groups.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class GroupMembershipTest < ActiveSupport::TestCase

  def valid_attributes
    {
      user_id: users(:no_group).id,
      user_group_id: user_groups(:default).id,
    }
  end

  test "it saves with valid attributes" do
    assert GroupMembership.new(valid_attributes).save!
  end
end

# typed: true

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
class GroupMembership < ApplicationRecord
  belongs_to :user
  belongs_to :user_group

  validates_uniqueness_of :user_id, scope: :user_group_id

  # has_paper_trail

  def user_id
    user&.id
  end

  def user_display_name
    user&.display_name
  end

  def user_username
    user&.username
  end
end

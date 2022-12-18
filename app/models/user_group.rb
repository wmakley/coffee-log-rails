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
class UserGroup < ApplicationRecord
  has_many :group_memberships, dependent: :destroy
  has_many :signup_codes, dependent: :destroy

  has_paper_trail
end

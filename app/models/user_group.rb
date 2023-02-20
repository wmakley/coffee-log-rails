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
  has_many :group_memberships, dependent: :restrict_with_error
  has_many :signup_codes, dependent: :restrict_with_error

  has_paper_trail

  scope :by_name, -> { order(:name) }

  before_validation do
    self.name = name&.squish.presence
  end

  validates :name,
            presence: true,
            length: { maximum: 255 }
end

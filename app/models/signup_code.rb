# frozen_string_literal: true

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
class SignupCode < ApplicationRecord
  belongs_to :user_group

  has_paper_trail

  validates :code,
            presence: true,
            uniqueness: true,
            length: {
              maximum: 100,
            }

  scope :active, -> { where(active: true) }
  scope :with_code, -> (code) { where(code: code) }
end

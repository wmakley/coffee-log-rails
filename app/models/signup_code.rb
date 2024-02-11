# frozen_string_literal: true
# typed: true

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

  # Fully normalize code, removing all invalid characters.
  # @return [String,nil] the normalized code, or nil if blank
  def self.normalize(code)
    code&.gsub(/[^A-Z0-9_-]/, "")&.presence&.upcase
  end

  # has_paper_trail

  validates :code,
    presence: true,
    uniqueness: true,
    format: {
      with: /\A[A-Z0-9_-]+\z/,
      message: "must contain only upper-case letters, numbers, '_', and '-'",
    },
    length: {
      maximum: 100,
    }

  # only trim whitespace, show explicit error to user to indicate expected values
  normalizes :code, with: ->(code) { code.strip.presence }

  scope :active, -> { where(active: true) }
  scope :with_code, ->(code) { where(code: code) }

  def user_group_name
    user_group&.name
  end
end

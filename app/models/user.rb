# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  admin        :boolean          default(FALSE), not null
#  display_name :string
#  password     :string           not null
#  preferences  :jsonb            not null
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
class User < ApplicationRecord
  has_one :log,
          foreign_key: :user_id,
          inverse_of: :user,
          dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :password,
            presence: true,
            length: { minimum: 6, maximum: 255 },
            format: /\A\S.*\S\z/
  validates :display_name, presence: true, uniqueness: true

  scope :by_name, -> { order(:display_name) }
end

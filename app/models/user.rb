# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  display_name :string
#  password     :string           not null
#  username     :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username)
#
class User < ApplicationRecord
  has_one :log, foreign_key: :user_id, inverse_of: :user

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  validates :display_name, presence: true
end

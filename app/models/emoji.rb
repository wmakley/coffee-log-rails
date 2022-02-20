# == Schema Information
#
# Table name: emojis
#
#  id         :bigint           not null, primary key
#  emoji      :string(4)        not null
#  name       :string(100)      not null
#  order      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_emojis_on_order  (order)
#
class Emoji < ApplicationRecord
  validates_presence_of :emoji, :name, :order
  validates_uniqueness_of :emoji, :name
  validates_numericality_of :order, only_integer: true

  has_many :likes, dependent: :restrict_with_error
end

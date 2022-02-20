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
require "test_helper"

class EmojiTest < ActiveSupport::TestCase
  def valid_attributes
    {
      emoji: "😢",
      name: "Crying",
      order: 1
    }
  end

  test "it saves with valid attributes" do
    emoji = Emoji.new(valid_attributes)
    assert emoji.save
  end
end

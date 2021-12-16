# == Schema Information
#
# Table name: roasts
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_roasts_on_name  (name) UNIQUE
#
require "test_helper"

class RoastTest < ActiveSupport::TestCase
  test "it saves with valid attributes" do
    assert Roast.create!({ name: "asdfasdfasdf" })
  end
end

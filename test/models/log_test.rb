# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_logs_on_slug  (slug) UNIQUE
#
require "test_helper"

class LogTest < ActiveSupport::TestCase
  test "it saves with valid attributes" do
    log = Log.new(name: "My Log", slug: "my-log")
    assert log.save
  end
end

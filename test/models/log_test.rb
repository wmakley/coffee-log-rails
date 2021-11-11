# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_logs_on_slug     (slug) UNIQUE
#  index_logs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class LogTest < ActiveSupport::TestCase
  fixtures :users

  test "it saves with valid attributes" do
    log = Log.new(name: "My Log", slug: "my-log", user: users(:default))
    assert log.save
  end
end

# == Schema Information
#
# Table name: logs
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  slug             :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owned_by_user_id :bigint           not null
#
# Indexes
#
#  index_logs_on_owned_by_user_id  (owned_by_user_id)
#  index_logs_on_slug              (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (owned_by_user_id => users.id)
#
require "test_helper"

class LogTest < ActiveSupport::TestCase
  fixtures :users

  test "it saves with valid attributes" do
    log = Log.new(name: "My Log", slug: "my-log", owned_by_user: users(:default))
    assert log.save
  end
end

# == Schema Information
#
# Table name: logs
#
#  id         :bigint           not null, primary key
#  slug       :string           not null
#  title      :string           not null
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

  def valid_attributes
    {
      title: "My Log",
      slug: "my-log",
      user_id: users(:default).id
    }
  end

  test "it saves with valid attributes" do
    log = Log.new(valid_attributes)
    assert log.save
  end
end

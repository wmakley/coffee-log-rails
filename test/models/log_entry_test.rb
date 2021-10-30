# == Schema Information
#
# Table name: log_entries
#
#  id           :bigint           not null, primary key
#  addl_notes   :text
#  coffee       :string           not null
#  coffee_grams :integer
#  deleted_at   :datetime
#  grind        :string
#  method       :string
#  tasting      :text
#  water        :string
#  water_grams  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  log_id       :bigint           not null
#
# Indexes
#
#  index_log_entries_on_log_id  (log_id)
#
# Foreign Keys
#
#  fk_rails_...  (log_id => logs.id)
#
require "test_helper"

class LogEntryTest < ActiveSupport::TestCase
  fixtures :logs

  def valid_attributes
    {
      log: logs(:default),
      coffee: "Test Coffee",
    }
  end

  test "saves with valid attributes" do
    entry = LogEntry.new(valid_attributes)
    assert entry.save
  end

  test "saving changes creates new version" do
    entry = LogEntry.create!(valid_attributes)
    entry.reload
    assert_equal 1, entry.log_entry_versions.size

    entry.update!(coffee: "New Coffee Value")
    entry.reload
    assert_equal 2, entry.log_entry_versions.size
    assert_equal "New Coffee Value", entry.log_entry_versions.last.coffee
  end
end

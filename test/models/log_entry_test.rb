# == Schema Information
#
# Table name: log_entries
#
#  id                :bigint           not null, primary key
#  acidity           :integer
#  addl_notes        :text
#  bitterness        :integer
#  body              :integer
#  coffee_grams      :integer
#  deleted_at        :datetime
#  entry_date        :datetime         not null
#  grind_notes       :string
#  overall_rating    :integer
#  preparation_notes :text
#  strength          :integer
#  tasting_notes     :text
#  water             :string
#  water_grams       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  brew_method_id    :bigint           not null
#  coffee_id         :bigint           not null
#  log_id            :bigint           not null
#
# Indexes
#
#  index_log_entries_on_brew_method_id         (brew_method_id)
#  index_log_entries_on_coffee_id              (coffee_id)
#  index_log_entries_on_log_id                 (log_id)
#  index_log_entries_on_log_id_and_entry_date  (log_id,entry_date) WHERE (deleted_at IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_...  (brew_method_id => brew_methods.id)
#  fk_rails_...  (coffee_id => coffees.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (log_id => logs.id)
#
require "test_helper"

class LogEntryTest < ActiveSupport::TestCase
  fixtures :all

  def valid_attributes
    {
      log: logs(:default),
      entry_date: Time.current,
      coffee: coffees(:one),
      brew_method: brew_methods(:other),
    }
  end

  test "saves with valid attributes" do
    entry = LogEntry.new(valid_attributes)
    assert entry.save
  end

  test "#mark_as_deleted" do
    entry = LogEntry.create!(valid_attributes)
    entry.mark_as_deleted!

    entry.reload
    assert_not_nil entry.deleted_at
    assert entry.deleted_at < Time.current

    log = entry.log
    log.reload
    assert_not(log.log_entries.any? { |e| e.id == entry.id })
  end

  test "input normalization" do
    entry = LogEntry.new

    entry.addl_notes = "line1\r\nline2\t"
    entry.valid?
    assert_equal "line1\nline2", entry.addl_notes

    entry.addl_notes = " line1\rline2 "
    entry.valid?
    assert_equal "line1\nline2", entry.addl_notes

    entry.addl_notes = "line1\n\nline2"
    entry.valid?
    assert_equal "line1\n\nline2", entry.addl_notes
  end
end

# == Schema Information
#
# Table name: log_entry_versions
#
#  id            :bigint           not null, primary key
#  addl_notes    :text
#  brew_method   :string
#  coffee_grams  :integer
#  deleted_at    :datetime
#  grind_notes   :string
#  tasting_notes :text
#  water         :string
#  water_grams   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  coffee_id     :bigint           not null
#  log_entry_id  :bigint           not null
#
# Indexes
#
#  index_log_entry_versions_on_log_entry_id  (log_entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (coffee_id => coffees.id) ON DELETE => restrict ON UPDATE => cascade
#  fk_rails_...  (log_entry_id => log_entries.id)
#
require "test_helper"

class LogEntryVersionTest < ActiveSupport::TestCase
  fixtures :logs, :log_entries, :coffees, :coffee_brands

  test "it saves with valid attributes" do
    entry = log_entries(:one)

    version = LogEntryVersion.new(
      log_entry: entry,
      coffee: entry.coffee
    )

    assert version.save, version.errors.full_messages.to_sentence
  end
end

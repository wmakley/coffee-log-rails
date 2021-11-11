# == Schema Information
#
# Table name: log_entry_versions
#
#  id            :bigint           not null, primary key
#  addl_notes    :text
#  brew_method   :string
#  coffee        :string
#  coffee_grams  :integer
#  deleted_at    :datetime
#  grind_notes   :string
#  tasting_notes :text
#  water         :string
#  water_grams   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  log_entry_id  :bigint           not null
#
# Indexes
#
#  index_log_entry_versions_on_log_entry_id  (log_entry_id)
#
# Foreign Keys
#
#  fk_rails_...  (log_entry_id => log_entries.id)
#
class LogEntryVersion < ApplicationRecord
  belongs_to :log_entry, optional: false, inverse_of: :log_entry_versions
end

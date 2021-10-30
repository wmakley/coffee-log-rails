# frozen_string_literal: true

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
class LogEntry < ApplicationRecord
  belongs_to :log, optional: false
  has_many :log_entry_versions,
           -> { order(:created_at) },
           dependent: :restrict_with_exception

  default_scope -> { live }
  scope :live, -> { where(deleted_at: nil) }

  after_save :save_version!, if: -> { previous_changes.present? }

  NEWLINE_REPLACEMENT_REGEX = /\r\n|\r(?!\n)/

  before_validation do
    self.coffee = coffee&.squish.presence
    self.water = water&.squish.presence
    self.method = method&.squish.presence
    self.grind = grind&.squish.presence
    self.tasting = tasting&.strip&.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence
    self.addl_notes = addl_notes&.strip&.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence
  end

  validates_presence_of :coffee

  validates_length_of :coffee,
                      :water,
                      :method,
                      :grind,
                      maximum: 255, allow_nil: true
  validates_length_of :tasting, :addl_notes,
                      maximum: 4000, allow_nil: true

  validates_numericality_of :coffee_grams,
                            :water_grams,
                            only_integer: true,
                            allow_blank: true


  def mark_as_deleted
    self.deleted_at = Time.current
    save_version!
    save
  end

  private

    def save_version!
      log_entry_versions.create!(
        log_entry: self,
        coffee: self.coffee,
        water: self.water,
        method: self.method,
        grind: self.grind,
        tasting: self.tasting,
        addl_notes: self.addl_notes,
        coffee_grams: self.coffee_grams,
        water_grams: self.water_grams,
        deleted_at: self.deleted_at
      )
    end
end

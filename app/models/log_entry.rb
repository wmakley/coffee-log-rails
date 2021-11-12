# frozen_string_literal: true

# == Schema Information
#
# Table name: log_entries
#
#  id            :bigint           not null, primary key
#  addl_notes    :text
#  brew_method   :string
#  coffee        :string           not null
#  coffee_grams  :integer
#  deleted_at    :datetime
#  entry_date    :datetime         not null
#  grind_notes   :string
#  tasting_notes :text
#  water         :string
#  water_grams   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  log_id        :bigint           not null
#
# Indexes
#
#  index_log_entries_on_log_id                 (log_id)
#  index_log_entries_on_log_id_and_entry_date  (log_id,entry_date) WHERE (deleted_at IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_...  (log_id => logs.id)
#
class LogEntry < ApplicationRecord
  belongs_to :log, inverse_of: :log_entries, optional: false
  has_many :log_entry_versions,
           -> { order(:created_at) },
           inverse_of: :log_entry,
           dependent: :delete_all

  default_scope -> { live }
  scope :live, -> { where(deleted_at: nil) }
  scope :by_date_desc, -> { order(entry_date: :desc) }

  after_save :save_version!, if: -> { previous_changes.present? }

  NEWLINE_REPLACEMENT_REGEX = /\r\n|\r(?!\n)/

  before_validation do
    self.coffee = coffee&.squish.presence
    self.water = water&.squish.presence
    self.brew_method = brew_method&.squish.presence
    self.grind_notes = grind_notes&.squish.presence
    self.tasting_notes = tasting_notes&.strip&.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence
    self.addl_notes = addl_notes&.strip&.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence
  end

  validates_presence_of :entry_date, :coffee

  validates_length_of :coffee,
                      :water,
                      :brew_method,
                      :grind_notes,
                      maximum: 255, allow_nil: true
  validates_length_of :tasting_notes, :addl_notes,
                      maximum: 4000, allow_nil: true

  validates_numericality_of :coffee_grams,
                            :water_grams,
                            only_integer: true,
                            allow_blank: true


  def mark_as_deleted!
    self.deleted_at = Time.current
    save_version!
    save!
  end

  def brew_ratio
    if coffee_grams.present? && water_grams.present?
      Rational(coffee_grams.to_i, water_grams.to_i)
    end
  end

  private

    def save_version!
      log_entry_versions.create!(
        log_entry: self,
        coffee: self.coffee,
        water: self.water,
        brew_method: self.brew_method,
        grind_notes: self.grind_notes,
        tasting_notes: self.tasting_notes,
        addl_notes: self.addl_notes,
        coffee_grams: self.coffee_grams,
        water_grams: self.water_grams,
        deleted_at: self.deleted_at
      )
    end
end

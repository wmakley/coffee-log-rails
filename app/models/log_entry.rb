# frozen_string_literal: true

# == Schema Information
#
# Table name: log_entries
#
#  id                    :bigint           not null, primary key
#  acidity               :integer
#  addl_notes            :text
#  bitterness            :integer
#  body                  :integer
#  coffee_grams          :integer
#  deleted_at            :datetime
#  entry_date            :datetime         not null
#  grind_notes           :string
#  grind_setting         :float
#  overall_rating        :integer
#  preparation_notes     :text
#  strength              :integer
#  tasting_notes         :text
#  water                 :string
#  water_grams           :integer
#  water_temp_in_celsius :float
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  brew_method_id        :bigint           not null
#  coffee_id             :bigint           not null
#  log_id                :bigint           not null
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
class LogEntry < ApplicationRecord
  belongs_to :log, inverse_of: :log_entries, optional: false, touch: true
  belongs_to :coffee, inverse_of: :log_entries, optional: false
  belongs_to :brew_method

  default_scope -> { live }
  scope :live, -> { where(deleted_at: nil) }
  scope :by_date_desc, -> { order(entry_date: :desc) }

  NEWLINE_REPLACEMENT_REGEX = /\r\n|\r(?!\n)/

  normalizes :water, with: ->(water) { water.squish.presence }
  normalizes :grind_notes, with: ->(grind_notes) { grind_notes.squish.presence }
  normalizes :tasting_notes, with: ->(tasting_notes) { tasting_notes.strip.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence }
  normalizes :addl_notes, with: ->(addl_notes) { addl_notes.strip.gsub(NEWLINE_REPLACEMENT_REGEX, "\n").presence }

  before_validation do
    if water_grams.is_a? String
      self.water_grams = water_grams.gsub(/\D/, "")
    end
    if coffee_grams.is_a? String
      self.coffee_grams = coffee_grams.gsub(/\D/, "")
    end
  end

  validates_presence_of :entry_date

  validates_length_of :water,
    :grind_notes,
    maximum: 255, allow_nil: true
  validates_length_of :tasting_notes, :preparation_notes, :addl_notes,
    maximum: 4000, allow_nil: true

  validates_numericality_of :coffee_grams,
    :water_grams,
    only_integer: true,
    allow_blank: true,
    minimum: 1

  validates_numericality_of :grind_setting,
    :water_temp_in_celsius,
    allow_blank: true

  # Ratings out of five
  validates_numericality_of :acidity, :body, :bitterness, :overall_rating,
    only_integer: true,
    allow_blank: true,
    minimum: 1, maximum: 5

  # Scale of -2 (too weak) to 2 (too strong), where zero is "perfect"
  validates :strength, numericality: {
    only_integer: true,
    allow_blank: true,
    minimum: -2, maximum: 2
  }

  def coffee_name
    coffee&.name
  end

  def coffee_roast
    coffee&.roast_name
  end

  def brew_method_name
    brew_method&.name
  end

  def mark_as_deleted!
    self.deleted_at = Time.current
    save!
  end

  def brew_ratio
    if coffee_grams.present? && water_grams.present? && coffee_grams.to_f > 0
      (water_grams.to_f / coffee_grams.to_f).round(2)
    end
  end

  def water_temperature
    Temperature.new(water_temp_in_celsius) if water_temp_in_celsius.present?
  end

  def water_temp_in_fahrenheit
    Temperature.new(water_temp_in_celsius).fahrenheit if water_temp_in_celsius.present?
  end

  def water_temp_in_fahrenheit=(input)
    self.water_temp_in_celsius = Temperature.fahrenheit(input).celsius
  end
end

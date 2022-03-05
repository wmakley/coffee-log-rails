# frozen_string_literal: true

module LogEntryHelper
  def log_entry_temp(log_entry)
    "#{log_entry.water_temp_in_fahrenheit}F" if log_entry&.water_temp_in_celsius.present?
  end

  def log_entry_grind_setting(log_entry)
    if log_entry&.grind_setting.present?
      "Grind: #{log_entry.grind_setting.to_i}"
    end
  end

  def log_entry_rating(log_entry)
    if log_entry&.overall_rating.present?
      "#{log_entry.overall_rating} out of 5"
    end
  end
end

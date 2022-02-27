# frozen_string_literal: true

namespace :data do
  desc "Populate numeric grind and water temp columns for old log entries by attempting to parse textual data"
  task :populate_grind_setting_and_water_temp => :environment do
    LogEntry.find_each do |log_entry|
      if log_entry.water_temp_in_fahrenheit.nil? && log_entry.water =~ /(\d+(\.\d+)?)F?/
        log_entry.water_temp_in_fahrenheit = $1.to_f
        puts "Entry #{log_entry.id}: Water #{log_entry.water} => #{log_entry.water_temp_in_fahrenheit}"
      end

      if log_entry.grind_setting.nil? && log_entry.grind_notes =~ /(\d+(\.\d+)?)T?/
        log_entry.grind_setting = $1.to_f
        puts "Entry #{log_entry.id}: Grind #{log_entry.grind_notes} => #{log_entry.grind_setting}"
      end

      log_entry.save! if log_entry.changed?
    end
  end
end

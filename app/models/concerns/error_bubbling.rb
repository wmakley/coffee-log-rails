# frozen_string_literal: true

module ErrorBubbling
  # Copy the error messages from record to self without any changes.
  def copy_errors_from(record)
    record.errors.each do |error|
      self.errors.add error.attribute, error.message
    end
  end
end

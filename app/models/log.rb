# frozen_string_literal: true

class Log < ApplicationRecord
  has_many :log_entries, dependent: :restrict_with_error
end

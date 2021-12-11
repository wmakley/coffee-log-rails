# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes
  attribute :user

  def admin?
    user&.admin?
  end
end

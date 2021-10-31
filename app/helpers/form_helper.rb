# frozen_string_literal: true

module FormHelper
  def invalid_message(object, field)
    if object.errors[field].present?
      content_tag(:div, class: "invalid-feedback") do
        "#{object.errors[field].to_sentence}."
      end
    end
  end
end

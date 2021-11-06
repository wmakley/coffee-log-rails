# frozen_string_literal: true

module FormHelper

  def vertical_input(form_builder, name, as: :text_field, label: nil)
    object = form_builder.object
    has_error = object.errors.present?

    input_classes = +"form-control"

    buffer = ActiveSupport::SafeBuffer.new
    buffer << form_builder.label(name, label, class: "form-label")
    buffer << form_builder.public_send(as, name, class: input_classes)
    buffer
  end

  def invalid_message(object, field)
    if object.errors[field].present?
      content_tag(:div, class: "invalid-feedback") do
        "#{object.errors[field].to_sentence}."
      end
    end
  end
end

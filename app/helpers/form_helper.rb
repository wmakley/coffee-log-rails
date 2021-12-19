# frozen_string_literal: true

module FormHelper

  # poor man's simple_form
  def input(form_builder, name, as: :text_field, label: nil, required: false,
            label_html: {},
            input_html: {})
    object = form_builder.object
    errors = object.errors[name]

    label_html[:class] ||= "form-label#{' required' if required}"

    input_classes = input_html.fetch(:class) { +"form-control#{' required' if required}" }

    # always add 'is-invalid' if there is an error
    if errors.present?
      input_classes = input_classes.dup if input_classes.frozen?
      input_classes << " is-invalid"
    end

    input_html[:class] = input_classes
    input_html[:required] = true if required

    buffer = ActiveSupport::SafeBuffer.new
    buffer << form_builder.label(name, label_html) do
      buf = ActiveSupport::SafeBuffer.new
      buf << label || name.to_s.titleize
      if required
        buf << " "
        buf << content_tag(:abbr, "*", title: "Required", class: "required")
      end
      buf
    end
    buffer << form_builder.public_send(as, name, input_html)
    buffer << invalid_feedback(errors) if errors.present?
    buffer
  end

  def invalid_message(object, field)
    invalid_feedback(object.errors[field])
  end

  def invalid_feedback(errors)
    if errors.present?
      content_tag(:div, class: "invalid-feedback") do
        "#{errors.to_sentence}."
      end
    end
  end
end

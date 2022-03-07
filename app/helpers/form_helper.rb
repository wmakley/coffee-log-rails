# frozen_string_literal: true

module FormHelper

  # poor man's simple_form
  def input(form_builder, name, as: :text_field, label: nil, required: false, collection: nil, include_blank: false, input_first: false,
            label_html: {},
            input_html: {})
    object = form_builder.object
    errors = object.errors[name]

    label_html[:class] ||= "form-label#{' required' if required}"

    input_classes = case as
                    when :select
                      input_html.fetch(:class) { +"form-select#{' required' if required}" }
                    else
                      input_html.fetch(:class) { +"form-control#{' required' if required}" }
                    end

    # always add 'is-invalid' if there is an error
    if errors.present?
      input_classes = input_classes.dup if input_classes.frozen?
      input_classes << " is-invalid"
    end

    input_html[:class] = input_classes
    input_html[:required] = true if required

    buffer = ActiveSupport::SafeBuffer.new

    if input_first
      if as == :select
        buffer << form_builder.select(name, collection, { include_blank: include_blank }, input_html)
      else
        buffer << form_builder.public_send(as, name, input_html)
      end

      buffer << form_builder.label(name, label_html) do
        buf = ActiveSupport::SafeBuffer.new
        buf << label || name.to_s.titleize
        if required
          buf << " "
          buf << content_tag(:abbr, "*", title: "Required", class: "required")
        end
        buf
      end
    else
      buffer << form_builder.label(name, label_html) do
        buf = ActiveSupport::SafeBuffer.new
        buf << label || name.to_s.titleize
        if required
          buf << " "
          buf << content_tag(:abbr, "*", title: "Required", class: "required")
        end
        buf
      end

      if as == :select
        buffer << form_builder.select(name, collection, { include_blank: include_blank }, input_html)
      else
        buffer << form_builder.public_send(as, name, input_html)
      end
    end

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

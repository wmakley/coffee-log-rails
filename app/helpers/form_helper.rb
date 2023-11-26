# frozen_string_literal: true

module FormHelper
  # @param [ActionView::Helpers::FormBuilder] form_builder the normal rails form builder
  # @param [Symbol] name the field name
  # @param [Hash] options
  # @option options [Symbol] :type The normal Rails input tag helper to use, e.g. :text_field, :email_field, etc.
  # @option options [Boolean] :required Whether the field is required
  # @option options [String] :modifiers Bulma modifiers to apply to the label, input, and icon wrappers
  # @return [ActiveSupport::SafeBuffer]
  def form_field(form_builder, name, **options)
    fb = BulmaFieldBuilder.new(self, form_builder, name, **options)
    content_tag(:div, class: "field") do
      yield fb
    end
  end

  # poor man's simple_form
  def input(form_builder, name, as: :text_field, label: nil, required: false, collection: nil, include_blank: false, input_first: false,
    label_html: {},
    input_html: {})
    object = form_builder.object
    errors = object.errors[name]

    label_html[:class] ||= "label#{" required" if required}"

    input_classes =
      case as
      when :select
        input_html.fetch(:class) { +"required" if required }
      else
        input_html.fetch(:class) { +"input#{" required" if required}" }
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
      buffer << content_tag(:div, class: "control") do
        if as == :select
          content_tag(:div, class: "select") do
            form_builder.select(name, collection, {include_blank: include_blank}, input_html)
          end
        else
          form_builder.public_send(as, name, input_html)
        end
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

      buffer << content_tag(:div, class: "control") do
        if as == :select
          content_tag(:div, class: "select") do
            form_builder.select(name, collection, {include_blank: include_blank}, input_html)
          end
        else
          form_builder.public_send(as, name, input_html)
        end
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
      content_tag(:p, class: "help is-danger") do
        "#{errors.to_sentence}."
      end
    end
  end
end

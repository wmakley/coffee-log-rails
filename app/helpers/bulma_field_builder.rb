# frozen_string_literal: true

class BulmaFieldBuilder
  def initialize(
    view,
    form_builder,
    name,
    type: :text_field,
    required: false,
    modifiers: nil
  )
    @view = view
    @form_builder = form_builder
    @name = name
    @type = type
    @required = required
    @modifiers = modifiers
  end

  def modifiers
    case @modifiers
    when Array
      @modifiers.join(" ")
    else
      @modifiers
    end
  end

  def label(*, **options, &)
    options[:class] ||= "label#{" required" if @required}"
    append_modifiers!(options, @modifiers)
    @form_builder.label(@name, *, options, &)
  end

  def control(modifiers: nil, **options, &)
    options[:class] ||= "control"
    append_modifiers!(options, modifiers)
    @view.content_tag(:div, options, &)
  end

  def input(**options)
    options[:class] ||= "input#{" is-danger" if has_error?}"
    options[:required] = true if @required
    append_modifiers!(options, @modifiers)
    @form_builder.public_send(@type, @name, **options)
  end

  def icon(modifiers, &)
    options = {class: "icon"}
    append_modifiers!(options, @modifiers)
    append_modifiers!(options, modifiers)
    @view.content_tag(:span, options, &)
  end

  def invalid_feedback
    return nil if valid?

    @view.content_tag(:p, "#{errors.to_sentence.capitalize}.", class: "help is-danger")
  end

  def valid_feedback(text)
    return nil if invalid?

    @view.content_tag(:p, text, class: "help is-success")
  end

  def value
    @form_builder.object.public_send(@name)
  end

  def errors
    @form_builder.object.errors[@name]
  end

  def has_error?
    errors.present?
  end

  def valid?
    !has_error?
  end

  alias_method :invalid?, :has_error?

  private

  def append_modifiers!(html_options, modifiers)
    return if modifiers.blank?

    html_options[:class] =
      case modifiers
      when String
        [html_options[:class], modifiers].compact_blank.join(" ")
      when Array
        [html_options[:class], *modifiers].compact_blank.join(" ")
      else
        raise TypeError, "modifiers must be String or Array<String>"
      end
  end
end

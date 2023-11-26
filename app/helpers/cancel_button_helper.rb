# frozen_string_literal: true

module CancelButtonHelper
  def cancel_button(url = :back, modifiers: "is-secondary", **html_options)
    classes =
      if html_options.has_key?(:class)
        html_options[:class].to_s
      else
        +"button"
      end

    if modifiers
      classes << " "
      classes << modifiers.to_s
    end

    html_options[:class] = classes

    link_to("Cancel", url, html_options)
  end
end

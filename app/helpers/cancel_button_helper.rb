# frozen_string_literal: true

module CancelButtonHelper
  def cancel_button(url = :back, html_options = {})
    classes = ["btn btn-secondary"]
    classes << html_options[:class] if html_options.has_key?(:class)

    link_options = html_options.merge(
      class: classes.join(" ")
    )

    link_to("Cancel", url, link_options)
  end
end

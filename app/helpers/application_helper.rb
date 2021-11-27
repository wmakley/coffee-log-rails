# frozen_string_literal: true

module ApplicationHelper
  def external_link(title, url, html_options = {})
    link_to(title, url, html_options.merge(target: "_blank", rel: "noopener noreferrer"))
  end
end

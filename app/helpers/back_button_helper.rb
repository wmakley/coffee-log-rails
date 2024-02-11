# frozen_string_literal: true

module BackButtonHelper
  extend T::Sig

  # Convenience for calling `link_to("Back", url_for_back(default_url), ...)`
  def link_to_back(name, default_url, options = {}, &block)
    no_edit = options.delete(:no_edit)
    back_url = options.delete(:back_url)
    link_to(name, url_for_back(default_url, no_edit: no_edit, back_url: back_url), options, &block)
  end

  # Custom context-sensitive wrapper for `url_for(:back)`.
  # Uses a default URL instead of javascript history if no
  # referrer.
  #
  # @param [String] default_url URL to use if no referrer
  # @param [Boolean] no_edit use default URL if referrer ends in "edit" or "new"
  # @param [String] back_url Override the back URL with something other than the referrer
  # @return [String]
  def url_for_back(default_url, no_edit: true, back_url: nil)
    url = back_url || url_for(:back)
    if url.starts_with?("javascript:") || (no_edit && (url.ends_with?("edit") || url.ends_with?("new")))
      url = default_url
    end
    url
  end
end

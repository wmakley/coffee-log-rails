module RecaptchaHelpers
  # include Recaptcha::Adapters::ViewMethods

  # The main issue with this script is it doesn't work with turbo drive. :-/
  # I worked around it by putting it outside a turbo frame that all login
  # screen interaction takes place in.
  def recaptcha_enterprise_script(site_key: Recaptcha.configuration.site_key, **)
    javascript_include_tag("https://www.google.com/recaptcha/enterprise.js?render=#{site_key}", **)
  end

  def recaptcha_response_field(options = {})
    options[:data] ||= {}
    options[:data][:recaptcha_v3_target] ||= "responseField"
    hidden_field_tag "g-recaptcha-response", nil, options
  end

  def recaptcha_protected_form_with(*, action:, **options, &block)
    @recaptcha_needed = true

    html = options[:html] || {}
    data = (html[:data] ||= {})
    data[:controller] = "recaptcha-v3"
    data[:recaptcha_v3_target] = "form"
    data[:recaptcha_v3_action_value] = action
    data[:recaptcha_v3_site_key_value] = Recaptcha.configuration.site_key
    data[:action] = "submit->recaptcha-v3#submit"
    modified_options = options.merge(html: html)

    form_with(*, **modified_options) do |f|
      buffer = ActiveSupport::SafeBuffer.new
      buffer << recaptcha_response_field
      buffer << capture(f, &block)
      buffer
    end
  end
end

module RecaptchaHelpers
  # include Recaptcha::Adapters::ViewMethods

  def recaptcha_enterprise_script(options = {})
    site_key = options.delete(:site_key) { Recaptcha.configuration.site_key }
    javascript_include_tag("https://www.google.com/recaptcha/enterprise.js?render=#{site_key}", options)
  end

  def recaptcha_response_field(options = {})
    options[:data] ||= {}
    options[:data][:recaptcha_v3_target] ||= "responseField"
    hidden_field_tag "g-recaptcha-response", nil, options
  end
end

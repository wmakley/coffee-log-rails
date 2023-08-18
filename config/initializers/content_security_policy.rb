# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https, 'https://cdn.jsdelivr.net'
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self, :https, 'inline', 'https://www.google.com/recaptcha/', 'https://www.gstatic.com/recaptcha/', 'https://www.recaptcha.net/'
    policy.frame_src   :self, :https, 'https://www.google.com/recaptcha/', 'https://recaptcha.google.com/recaptcha/'
    policy.style_src   :self, :https, "'unsafe-inline'"
    # Specify URI for violation reports
    policy.report_uri "https://fdl3vgy26hvmtjgl3hxhvshe4a0aerqf.lambda-url.us-east-1.on.aws/"
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src)

  # Report CSP violations to a specified URI. See:
  # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
  # config.content_security_policy_report_only = true
end

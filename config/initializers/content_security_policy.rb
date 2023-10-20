# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.script_src  :self, :https
#     policy.style_src   :self, :https
#     # Specify URI for violation reports
#     # policy.report_uri "/csp-violation-report-endpoint"
#   end
#
#   # Generate session nonces for permitted importmap, inline scripts, and inline styles.
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)
#
#   # Report violations without enforcing the policy.
#   # config.content_security_policy_report_only = true
# end

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, 'https://cdn.jsdelivr.net', 'https://ga.jspm.io/'
#     policy.font_src    :self, :data, 'https://cdn.jsdelivr.net'
#     policy.img_src     :self, :data, 'https://cdn.jsdelivr.net', 'https://coffee-log-rails.s3.amazonaws.com/', 'https://coffee-log-rails-development.s3.amazonaws.com/'
#     policy.object_src  :none
#     policy.script_src  :self, 'https://cdn.jsdelivr.net', 'https://ga.jspm.io/', 'https://www.google.com/recaptcha/', 'https://www.gstatic.com/recaptcha/', 'https://www.recaptcha.net/recaptcha/'
#     policy.frame_src   :self, 'https://www.google.com/recaptcha/', 'https://recaptcha.google.com/recaptcha/', 'https://www.recaptcha.net/recaptcha/'
#     policy.style_src   :self, 'https://cdn.jsdelivr.net'
#     # Specify URI for violation reports
#     policy.report_uri "https://fdl3vgy26hvmtjgl3hxhvshe4a0aerqf.lambda-url.us-east-1.on.aws/"
#   end
#
#   # Generate session nonces for permitted importmap and inline scripts
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src style-src)
#
#   # Report CSP violations to a specified URI. See:
#   # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
#   # config.content_security_policy_report_only = true
# end

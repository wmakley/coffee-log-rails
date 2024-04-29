# Be sure to restart your server when you modify this file.

# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Use this to limit dissemination of sensitive information.
# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.
Rails.application.config.filter_parameters += [
  # defaults:
  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn,
  # custom:
  :email_verification_token, :password_digest, :reset_password_token
]

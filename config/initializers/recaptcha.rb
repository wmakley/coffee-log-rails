Recaptcha.configure do |config|
  config.enterprise = true
  config.site_key = ENV["RECAPTCHA_SITE_KEY"] || Rails.application.credentials.dig(Rails.env.to_sym, :recaptcha, :site_key)
  config.enterprise_project_id = ENV["RECAPTCHA_ENTERPRISE_PROJECT_ID"] || Rails.application.credentials.dig(Rails.env.to_sym, :recaptcha, :enterprise_project_id)
  config.enterprise_api_key = ENV["RECAPTCHA_ENTERPRISE_API_KEY"] || Rails.application.credentials.dig(Rails.env.to_sym, :recaptcha, :enterprise_api_key)
end

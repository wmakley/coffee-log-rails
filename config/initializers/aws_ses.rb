require 'aws/ses'

ActionMailer::Base.add_delivery_method :ses, AWS::SES::Base,
  access_key_id: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :access_key_id),
  secret_access_key: Rails.application.credentials.dig(Rails.env.to_sym, :aws, :secret_access_key)

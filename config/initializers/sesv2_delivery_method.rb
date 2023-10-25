require_relative "../../lib/delivery_methods/sesv2"

ActionMailer::Base.add_delivery_method :ses, DeliveryMethods::Sesv2,
  region: ENV["AWS_REGION"] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :region),
  credentials: Aws::Credentials.new(
    ENV["AWS_ACCESS_KEY_ID"] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :access_key_id),
    ENV["AWS_SECRET_ACCESS_KEY"] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :secret_access_key)
  )

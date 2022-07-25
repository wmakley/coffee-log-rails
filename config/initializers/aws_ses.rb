credentials = Rails.application.credentials.dig(Rails.env.to_sym, :aws)

ActionMailer::Base.add_delivery_method :ses, Aws::SESV2::Client,
  region: ENV['AWS_REGION'] || credentials.region,
  credentials: {
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] || credentials.access_key_id,
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || credentials.secret_access_key,
  }

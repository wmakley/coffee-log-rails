class SESV2DeliveryMethod
  def initialize(client_params)
    @client = Aws::SESV2::Client.new(client_params)
  end

  attr_reader :client

  # @param [Mail::Message] mail
  def deliver!(mail)
    client.send_email(
      {
        from_email_address: Array(mail.from).first,
        destination: {
          to_addresses: mail.destinations,
        },
        content: {
          raw: {
            data: mail.encoded,
          },
        }
      }
    )
  end
end

ActionMailer::Base.add_delivery_method :ses, SESV2DeliveryMethod,
  region: ENV['AWS_REGION'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :region),
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :access_key_id),
    ENV['AWS_SECRET_ACCESS_KEY'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :secret_access_key)
  )

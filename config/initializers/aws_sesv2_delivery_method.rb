# Possible alternative (especially if I were using SQS or Dynamo DB): https://github.com/aws/aws-sdk-rails

# ActionMailer delivery method for AWS SESv2 SDK
class SESV2DeliveryMethod
  # @param [Hash] options The exact arguments to pass to Aws::SESV2::Client#initialize. See: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SESV2/Client.html#initialize-instance_method
  def initialize(options)
    @client = Aws::SESV2::Client.new(options)
  end

  # @param [Mail::Message] mail
  def deliver!(mail)
    @client.send_email(
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

  def settings
    {}
  end
end

ActionMailer::Base.add_delivery_method :ses, SESV2DeliveryMethod,
  region: ENV['AWS_REGION'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :region),
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :access_key_id),
    ENV['AWS_SECRET_ACCESS_KEY'] || Rails.application.credentials.dig(Rails.env.to_sym, :aws, :secret_access_key)
  )

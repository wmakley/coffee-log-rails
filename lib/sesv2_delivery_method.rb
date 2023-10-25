# ActionMailer delivery method for AWS SESv2 SDK
# Possible alternative (especially if I were using SQS or Dynamo DB): https://github.com/aws/aws-sdk-rails
class Sesv2DeliveryMethod
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
          to_addresses: mail.destinations
        },
        content: {
          raw: {
            data: mail.encoded
          }
        }
      }
    )
  end

  def settings
    {}
  end
end

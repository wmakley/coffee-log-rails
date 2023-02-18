# frozen_string_literal: true

module EmailVerification
  def generate_email_verification_token!
    10.times do |n|
      self.email_verification_token = SecureRandom.hex(16)
      break unless self.class.exists?(email_verification_token: email_verification_token)
      if n >= 9
        raise "max attempts to generate verification token exceeded"
      end
    end

    email_verification_token
  end
end

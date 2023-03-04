# frozen_string_literal: true

module EmailVerification
  def needs_email_verification?
    email_verified_at.blank?
  end

  def email_verified?
    email_verified_at.present?
  end

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

  def mark_email_verified!
    self.email_verified_at = Time.current
    self.email_verification_token = nil
  end

  def generate_new_verification_token_and_send_email!
    self.class.transaction do
      generate_email_verification_token!
      save!
    end
    EmailVerificationMailer.with(user: self).verification_link.deliver_later
    self
  end
end

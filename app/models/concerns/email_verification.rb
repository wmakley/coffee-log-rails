# frozen_string_literal: true

# Methods implementing email verification business logic, but no callbacks.
# All mutating methods return self.
module EmailVerification
  def needs_email_verification?
    !email_verified?
  end

  def email_verified?
    email_verified_at.present?
  end

  def verification_email_sent?
    verification_email_sent_at.present?
  end

  def start_verification_process!
    generate_email_verification_token!
    will_send_verification_email!
  end

  # Set verification_email_sent_at to the current time
  def will_send_verification_email!
    self.verification_email_sent_at = Time.current
    self
  end

  def generate_email_verification_token!
    raise "new_email is required so there is something to verify" if new_email.blank?

    10.times do |n|
      self.email_verification_token = SecureRandom.hex(16)
      break unless self.class.exists?(email_verification_token: email_verification_token)
      if n >= 9
        raise "max attempts to generate verification token exceeded"
      end
    end

    self
  end

  # Clear verification token and swap new_email with email. Does not save.
  def mark_email_verified!
    self.email = new_email
    self.new_email = nil
    self.email_verified_at = Time.current
    self.email_verification_token = nil
    self
  end

  # Within a transaction, generate a new token, save the record, and send verification email
  def generate_new_verification_token_and_send_email!
    logger.debug "generate_new_verification_token_and_send_email!"
    self.class.transaction do
      self.new_email ||= email
      generate_email_verification_token!
      self.verification_email_sent_at = Time.current
      save!
    end
    # TODO: might be nice to nullify the "sent at" value if email delivery fails
    send_verification_email
    self
  end

  def send_verification_email
    EmailVerificationMailer.with(user: self).verification_link.deliver_later
  end

  def send_verification_email_if_not_sent_recently!
    if !verification_email_sent_at || verification_email_sent_at < 5.minutes.ago
      generate_new_verification_token_and_send_email!
    end
  end
end

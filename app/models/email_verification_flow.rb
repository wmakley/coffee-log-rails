class EmailVerificationFlow
  # @param [User] user
  def initialize(user)
    @user = user
  end

  def start_verification_process!
    generate_email_verification_token!
    will_send_verification_email!
  end

  # Set verification_email_sent_at to the current time
  def will_send_verification_email!
    @user.verification_email_sent_at = Time.current
    self
  end

  def generate_email_verification_token!
    raise "new_email is required so there is something to verify" if @user.new_email.blank?

    10.times do |n|
      @user.email_verification_token = SecureRandom.hex(16)
      break unless User.exists?(email_verification_token: @user.email_verification_token)
      if n >= 9
        raise "max attempts to generate verification token exceeded"
      end
    end

    self
  end

  # Clear verification token and swap new_email with email. Does not save.
  def mark_email_verified!
    @user.email = @user.new_email
    @user.new_email = nil
    @user.email_verified_at = Time.current
    @user.email_verification_token = nil
    self
  end

  # Within a transaction, generate a new token, save the record, and send verification email
  def generate_new_verification_token_and_send_email!
    logger.debug "generate_new_verification_token_and_send_email!"
    User.transaction do
      @user.new_email ||= @user.email
      generate_email_verification_token!
      @user.verification_email_sent_at = Time.current
      @user.save!
    end
    # TODO: might be nice to nullify the "sent at" value if email delivery fails
    send_verification_email
    self
  end

  def send_verification_email
    EmailVerificationMailer.with(user: @user).verification_link.deliver_later
  end

  def send_verification_email_if_not_sent_recently!
    if !@user.verification_email_sent_at || @user.verification_email_sent_at < 5.minutes.ago
      generate_new_verification_token_and_send_email!
    end
  end

  def logger
    Rails.logger
  end
end

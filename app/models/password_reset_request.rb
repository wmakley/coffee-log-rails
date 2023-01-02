# frozen_string_literal: true

class PasswordResetRequest
  include ActiveModel::Model

  attr_accessor :email

  validates :email, presence: true, format: /@/

  def invalid_email?
    @invalid_email
  end

  # Returns false for programming errors only, true whether or not the reset succeeded
  def save
    return false unless valid?

    user = nil
    User.transaction do
      user = User.where("lower(email) = ?", email.strip.downcase).first
      unless user
        logger.info "Email address '#{email}' not found, recording failed attempt"
        @invalid_email = true
        raise ActiveRecord::Rollback
      end

      user.generate_reset_password_token!
      unless user.save
        user.errors.each do |error|
          self.errors.add(:user, error.full_message)
        end
        # self.errors = user.errors
        logger.error "Error saving User: #{errors.full_messages.inspect}"
        raise ActiveRecord::Rollback
      end
    end

    return false if errors.present?

    return true if user.nil?

    PasswordResetRequestMailer.with(user: user)
                              .reset_password_link
                              .deliver_later

    true
  end

  def logger
    Rails.logger
  end
end

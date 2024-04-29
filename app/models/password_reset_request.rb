# frozen_string_literal: true

class PasswordResetRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email, :string

  validates :email, presence: true, format: /@/

  def invalid_email?
    @invalid_email
  end

  # @raise ActiveRecord::RecordInvalid on form validation errors
  def save!
    if !save
      raise ActiveRecord::RecordInvalid, self
    end
    true
  end

  # Returns false for validation errors only, true whether or not the request succeeded
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
          errors.add(:user, error.full_message)
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

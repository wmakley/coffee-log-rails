# frozen_string_literal: true

module ResetPasswordToken
  extend ActiveSupport::Concern

  RESET_TOKEN_VALID_FOR = 1.hour

  def reset_password_token_valid?
    reset_password_token.present? && reset_password_token_created_at >= RESET_TOKEN_VALID_FOR.ago
  end

  def reset_password_token_expired?
    reset_password_token_created_at < RESET_TOKEN_VALID_FOR.ago
  end

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.hex(16)
    self.reset_password_token_created_at = Time.now.utc
  end

  included do
    scope :reset_password_token, -> (token) { where(reset_password_token: token.to_s) }
  end
end

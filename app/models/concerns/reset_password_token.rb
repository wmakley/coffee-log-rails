# frozen_string_literal: true

module ResetPasswordToken
  extend ActiveSupport::Concern

  RESET_TOKEN_VALID_FOR = 1.hour

  def reset_password_token_expired?
    reset_password_token_created_at < RESET_TOKEN_VALID_FOR.ago
  end

  def generate_reset_password_token!
    self.reset_password_token = SecureRandom.hex(16)
    self.reset_password_token_created_at = Time.now.utc
  end

  def clear_reset_password_token!
    self.reset_password_token = nil
    self.reset_password_token_created_at = nil
  end

  included do
    scope :reset_password_token, ->(token) { where(reset_password_token: token.to_s) }

    before_save do
      clear_reset_password_token! if will_save_change_to_password_digest?
    end
  end
end

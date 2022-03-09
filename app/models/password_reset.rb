# frozen_string_literal: true

class PasswordReset
  include ActiveModel::Model

  RESET_TOKEN_VALID_FOR = 1.hour

  attr_accessor :token,
                :password,
                :password_confirmation

  validates_presence_of :token,
                        :password,
                        :password_confirmation

  def invalid_token?
    @invalid_token
  end

  def expired_token?
    @expired_token
  end

  def save
    return false unless valid?

    User.transaction do
      user = User.find_by(reset_password_token: token.to_s)
      unless user
        errors.add(:token, "is invalid")
        @invalid_token = true
        raise ActiveRecord::Rollback
      end

      if user.reset_password_token_expired?
        @expired_token = true
        errors.add(:token, "has expired")
        raise ActiveRecord::Rollback
      end

      unless user.reset_password_token_valid?
        raise "unhandled error case"
      end

      user.password = password
      user.password_confirmation = password_confirmation

      unless user.save
        self.errors = user.errors
        raise ActiveRecord::Rollback
      end

      user.clear_reset_password_token!
    end

    errors.blank?
  end

  def logger
    Rails.logger
  end
end

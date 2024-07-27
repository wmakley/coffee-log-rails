# frozen_string_literal: true

class EmailVerificationForm
  include ActiveModel::Model

  attr_accessor :email, :token, :submit_immediately

  validates :email, presence: true
  validates :token, presence: true

  def submit_immediately?
    submit_immediately == "1"
  end

  def save
    user = User.find_by(email: email.to_s, email_verification_token: token.to_s)
    if user.nil?
      # generic error that doesn't reveal what the issue is (may expand on later)
      errors.add(:base, "email or token is invalid")
      return false
    end

    user.email_verification_flow.mark_email_verified!
    user.save!
    user
  end
end

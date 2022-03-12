# Preview all emails at http://localhost:3000/rails/mailers/password_reset_request_mailer
class PasswordResetRequestMailerPreview < ActionMailer::Preview
  def reset_password_link
    user = User.first
    user.generate_reset_password_token! # without saving
    PasswordResetRequestMailer.with(user: user).reset_password_link
  end
end

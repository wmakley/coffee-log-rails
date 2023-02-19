# frozen_string_literal: true

class SignupForm
  include ActiveModel::Model

  attr_accessor :code
  attr_accessor :email
  attr_accessor :display_name
  attr_accessor :password
  attr_accessor :password_confirmation

  def invalid_code?
    @invalid_code
  end

  validates_presence_of :code,
                        :email,
                        :display_name,
                        # Password validation is delegated to the User model in #save, here
                        # we just make sure the form is filled out.
                        :password,
                        :password_confirmation

  # @return [User,FalseClass]
  def save
    self.code = code&.strip.presence&.upcase
    self.email = email&.strip.presence

    return false unless valid?

    user = nil
    User.transaction do
      signup_code = SignupCode.active.find_by(code: code)
      if signup_code.nil?
        @invalid_code = true
        errors.add(:code, "is invalid")
        raise ActiveRecord::Rollback
      end

      logger.info "Using SignupCode: #{signup_code.inspect}"

      user = User.new(
        username: email,
        email: email,
        display_name: display_name,
        password: password,
        password_confirmation: password_confirmation,
      )
      user.generate_email_verification_token!
      unless user.save
        self.errors = user.errors
        raise ActiveRecord::Rollback
      end

      user.group_memberships.create!(user_group: signup_code.user_group)
    end

    return false if errors.present?

    SignupFormMailer.with(user: user)
                    .welcome_email
                    .deliver_later
    user
  end

  def logger
    Rails.logger
  end
end

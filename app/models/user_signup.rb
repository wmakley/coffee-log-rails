# Models a user signing up for an account on the public signup form,
# using a signup code.
class UserSignup
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ErrorBubbling

  attribute :code, :string
  attribute :new_email, :string
  attribute :display_name, :string
  attribute :password, :string
  attribute :password_confirmation, :string

  alias_method :email, :new_email

  def invalid_code?
    @invalid_code
  end

  validates_presence_of :code,
    :new_email,
    :display_name,
    # Password validation is delegated to the User model in #save, here
    # we just make sure the form is filled out.
    :password,
    :password_confirmation

  # @return [User,FalseClass]
  def save
    self.code = SignupCode.normalize(code)
    self.new_email = new_email&.strip.presence

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
        email: new_email,
        new_email: new_email,
        display_name: display_name,
        password: password,
        password_confirmation: password_confirmation,
      )
      user.generate_email_verification_token!
      unless user.save
        copy_errors_from(user)
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

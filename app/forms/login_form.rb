# frozen_string_literal: true

# Validates form inputs structurally. No business logic.
class LoginForm
  include ActiveModel::Model

  attr_accessor :username, :password

  validates_presence_of :username, :password, message: "%{attribute} is required"

  def persisted?
    false
  end
end

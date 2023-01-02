# frozen_string_literal: true

# Validates form inputs structurually. No business logic.
class LoginForm
  include ActiveModel::Model

  attr_accessor :username, :password

  validates_presence_of :username, :password

  def persisted?
    false
  end
end

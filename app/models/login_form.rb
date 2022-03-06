# frozen_string_literal: true

class LoginForm
  include ActiveModel::Model

  attr_accessor :username, :password

  validates_presence_of :username, :password

  def persisted?
    false
  end
end

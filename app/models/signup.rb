# frozen_string_literal: true

class Signup
  include ActiveModel::Model

  attr_accessor :code
  attr_accessor :email
  attr_accessor :password
  attr_accessor :password_confirmation

  validates_presence_of :code,
                        :email,
                        :password,
                        :password_confirmation
end

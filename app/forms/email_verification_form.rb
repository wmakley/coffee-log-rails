# frozen_string_literal: true

class EmailVerificationForm
  include ActiveModel::Model

  attr_accessor :email, :token

  validates :email, presence: true
  validates :token, presence: true
end

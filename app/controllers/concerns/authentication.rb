# frozen_string_literal: true

module Authentication
  class AuthenticationError < StandardError; end

  class NotLoggedInError < AuthenticationError; end
end

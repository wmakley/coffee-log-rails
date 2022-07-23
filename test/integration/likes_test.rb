# frozen_string_literal: true

class LikesTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    login_as users(:default)
  end
end

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def host
    Capybara.current_session.server.host
  end

  def port
    Capybara.current_session.server.port
  end

  def current_user
    @user
  end

  delegate :username, :password, to: :current_user

  # Overridden to support http
  def visit_with_basic_auth(path)
    visit "http://#{username}:#{password}@#{host}:#{port}#{path}"
  end
end

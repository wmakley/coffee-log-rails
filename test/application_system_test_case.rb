require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def before_setup
    super
    ApplicationController.disable_authentication = true
  end

  def after_teardown
    super
    remove_uploaded_files
    ApplicationController.disable_authentication = false
  end

  def remove_uploaded_files
    FileUtils.rm_rf("#{Rails.root}/storage_test")
  end

  def current_user
    @user
  end

  delegate :username, :password, to: :current_user

  # Does not work persistently as user navigates :(
  def visit_with_basic_auth(path, un = username, pw = password)
    visit "http://#{un}:#{pw}@#{host}:#{port}#{path}"
  end

  def host
    Capybara.current_session.server.host
  end

  def port
    Capybara.current_session.server.port
  end
end

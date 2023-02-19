# frozen_string_literal: true

require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  prepend LoginAs
  include AppSpecificAssertions

  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def after_teardown
    super
    remove_uploaded_files
  end

  def remove_uploaded_files
    FileUtils.rm_rf("#{Rails.root}/storage_test")
  end

  def current_user
    @user
  end

  delegate :username, :password, to: :current_user

  def host
    Capybara.current_session.server.host
  end

  def port
    Capybara.current_session.server.port
  end
end

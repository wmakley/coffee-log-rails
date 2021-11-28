# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def authorization_header(username, password)
    {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    }
  end

  def valid_login
    authorization_header('default', 'password')
  end

  def assert_notice(message)
    assert_select("#flash > .alert.alert-success", message)
  end

  def assert_error(message)
    assert_select("#flash > .alert.alert-danger", message)
  end

  def disable_authentication
    ApplicationController.disable_authentication = true
  end

  def enable_authentication
    ApplicationController.disable_authentication = false
  end
end

module RemoveUploadedFiles
  def after_teardown
    super
    remove_uploaded_files
  end

  private

    def remove_uploaded_files
      FileUtils.rm_rf(Rails.root.join('tmp', 'storage'))
    end
end

module ActionDispatch
  class IntegrationTest
    prepend RemoveUploadedFiles
  end
end

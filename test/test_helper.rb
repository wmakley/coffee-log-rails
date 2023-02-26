# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require_relative "./random_test_data"

class ActiveSupport::TestCase
  include RandomTestData

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  TEST_USERNAME = 'default'
  TEST_PASSWORD = 'password'

  def with_unique_number
    @_unique_number ||= 0
    @_unique_number += 1
    yield @_unique_number
  end
end

module AppSpecificAssertions
  def assert_redirected_to_app
    assert_redirected_to "/logs"
    follow_redirect!
    assert_redirected_to %r{/logs/[\w\d\-]+/entries}
  end

  def assert_redirected_to_login
    assert_redirected_to "/session/new"
  end

  def assert_notice(message)
    if respond_to? :assert_selector
      assert_selector("#flash > .alert.alert-success", text: message)
    else
      assert_select("#flash > .alert.alert-success", message)
    end
  end

  def assert_error(message)
    if respond_to? :assert_selector
      assert_selector("#flash > .alert.alert-danger", text: message)
    else
      assert_select("#flash > .alert.alert-danger", message)
    end
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

module LoginAs
  def login_as(user)
    user = users(user) if user.is_a? Symbol
    Current.user = user
    ApplicationController.stub_current_user = user
  end

  def after_teardown
    super
    Current.user = nil
    ApplicationController.stub_current_user = nil
  end
end

module ActionDispatch
  class IntegrationTest
    prepend RemoveUploadedFiles
    prepend LoginAs
    include AppSpecificAssertions
  end
end

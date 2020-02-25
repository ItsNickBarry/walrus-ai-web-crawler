ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start :rails unless ENV['NO_COVERAGE']

require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/spec'
require 'minitest/reporters'
require 'minitest/reporters/ordered_spec_reporter'
require 'minitest_autoskip'

Minitest::Reporters.use! Minitest::Reporters::OrderedSpecReporter.new({
  loose: true,
  truncate: true,
})

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # parallelize compatibility with simplecov
  # https://github.com/colszowka/simplecov/issues/718
  unless ENV['NO_COVERAGE']
    parallelize_setup do |worker|
      SimpleCov.command_name "#{ SimpleCov.command_name }-#{ worker }"
    end

    parallelize_teardown do |worker|
      SimpleCov.result
    end
  end

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  before do
    Bullet.start_request
  end

  after do
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end
end

class ActionDispatch::IntegrationTest
  def json_response
    @json_response ||= ActiveSupport::JSON.decode response.body
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/rails"
require "minitest/reporters"
require "mocha/minitest"

# SimpleCov for code coverage
require "simplecov"
SimpleCov.start "rails" do
  add_filter "/vendor/"
  add_filter "/test/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/bin/"
  add_filter "/log/"
  add_filter "/tmp/"
  add_filter "/app/channels/"
  add_filter "/app/jobs/"
  add_filter "/app/mailers/"

  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Views", "app/views"
  add_group "Helpers", "app/helpers"
end

# Configure Minitest reporters
Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true),
  Minitest::Reporters::ProgressReporter.new
]

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Use transactional fixtures to clean database between tests
  self.use_transactional_tests = true

  # Add more helper methods to be used by all tests here...

  # Helper method to create a profile with valid attributes
  def valid_profile_attributes
    {
      name: "Test User #{rand(1000)}",
      github_url: "https://github.com/testuser#{rand(1000)}"
    }
  end

  # Helper method to create a profile
  def create_profile(attributes = {})
    Profile.create!(valid_profile_attributes.merge(attributes))
  end
end

class ActionDispatch::IntegrationTest
  # Integration test helpers can be added here

  # Reset sessions between tests
  teardown do
    # Clean up any test data if needed
  end
end

ENV["RAILS_ENV"] ||= "test"
if ENV["RAILS_ENV"] == "test" && $PROGRAM_NAME == "bin/rails"
  require "simplecov"
  SimpleCov.start :rails do
    # SimpleCov.command_name "#{ENV['TEST_ENV_NUMBER']}/#{ENV["PARALLEL_TEST_GROUPS"]}"
    enable_coverage :branch
    # primary_coverage :branch
    minimum_coverage 70
    # minimum_coverage line: 19, branch: 19
    # minimum_coverage_by_file line: 90, branch: 80
  end
  puts "required simplecov"
  end

require_relative "../config/environment"
require "rails/test_help"
require "vcr"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
  VCR.configure do |config|
    config.cassette_library_dir = "test/fixtures/vcr_cassettes"
    config.hook_into :webmock
    config.filter_sensitive_data("dummy-genius-access-token") { ENV['GENIUS_ACCESS_TOKEN'] }
  end

end

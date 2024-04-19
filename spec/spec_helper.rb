# frozen_string_literal: true

require "dotenv"
Dotenv.load(".env.test.local", ".env.test")

require "webmock/rspec"
require_relative "support/simplecov"
require_relative "support/vcr"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.order = :random
  Kernel.srand config.seed
end

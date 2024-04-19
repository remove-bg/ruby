# frozen_string_literal: true

require "vcr"
require "vcr_better_binary"

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("../fixtures/vcr_cassettes", __dir__)
  config.hook_into :webmock

  config.filter_sensitive_data("<REMOVE-BG-API-KEY>") do |interaction|
    interaction.request.headers["X-Api-Key"].first
  end

  config.cassette_serializers[:better_binary] = VcrBetterBinary::Serializer.new
  config.default_cassette_options = { serialize_with: :better_binary }
end

RSpec.configure do |config|
  config.before(:example, :disable_vcr) do
    VCR.turn_off!
  end

  config.after(:example, :disable_vcr) do
    VCR.turn_on!
  end

  config.after(:suite) do
    VcrBetterBinary::Serializer.new.prune_bin_data
  end
end

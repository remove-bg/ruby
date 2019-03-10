require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = File.expand_path("../fixtures/vcr_cassettes", __dir__)
  config.hook_into :webmock

  config.filter_sensitive_data("<REMOVE-BG-API-KEY>") do |interaction|
    interaction.request.headers["X-Api-Key"].first
  end
end

# frozen_string_literal: true

require "simplecov"
require "simplecov-cobertura"
require "simplecov_json_formatter"

SimpleCov.formatters = [
  SimpleCov::Formatter::SimpleFormatter,
  SimpleCov::Formatter::CoberturaFormatter,
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
]

SimpleCov.start "rails" do
  # ignore common ruby and ruby on rails files in test coverage
  add_filter "Gemfile"

  # Ignore Rails binaries
  add_filter "bin"

  # Ignore Specs/tests themselves
  add_filter "spec"
end

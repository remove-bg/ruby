# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remove_bg/version"

Gem::Specification.new do |spec|
  spec.name = "remove_bg"
  spec.version = RemoveBg::VERSION
  spec.authors = ["Canva Austria GmbH"]
  spec.email = ["ops@kaleido.ai"]

  spec.platform = Gem::Platform::RUBY

  spec.summary = "Remove image background - 100% automatically"
  spec.description = "Use remove.bg with our official Ruby library to quickly, easily and 100% automatically remove the background from images."
  spec.homepage = "https://www.remove.bg/"
  spec.license = "MIT"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/remove-bg/ruby/issues",
    "source_code_uri" => "https://github.com/remove-bg/ruby",
    "changelog_uri" => "https://github.com/remove-bg/ruby/blob/main/CHANGELOG.md",
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true",
  }

  # Require at least Ruby 2.7
  spec.required_ruby_version = ">= 2.7"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 0.15", "< 3"
  spec.add_dependency "image_processing", ">= 1.9", "< 2"
  spec.add_dependency "rubyzip", ">= 2.0", "< 3"

  spec.add_development_dependency "appraisal", "~> 2.5"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rspec_junit_formatter", "~> 0.6"
  spec.add_development_dependency "rspec-sonarqube-formatter", "~> 1.5"
  spec.add_development_dependency "rspec-with_params", "~> 0.3"
  spec.add_development_dependency "rubocop", "~> 1.63"
  spec.add_development_dependency "rubocop-performance", "~> 1.21"
  spec.add_development_dependency "rubocop-rake", "~> 0.6.0"
  spec.add_development_dependency "rubocop-rspec", "~> 2.29"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "simplecov-cobertura", "~> 2.1"
  spec.add_development_dependency "simplecov_json_formatter", "~> 0.1"
  spec.add_development_dependency "vcr", "~> 6.2"
  spec.add_development_dependency "vcr_better_binary", "~> 0.2"
  spec.add_development_dependency "webmock", "~> 3.23"
  spec.add_development_dependency "yard", "~> 0.9"
end

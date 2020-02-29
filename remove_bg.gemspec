lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "remove_bg/version"

Gem::Specification.new do |spec|
  spec.name = "remove_bg"
  spec.version = RemoveBg::VERSION
  spec.authors = ["Oliver Peate"]
  spec.email = ["team@remove.bg"]

  spec.summary = "Remove image background - 100% automatically"
  spec.homepage = "https://www.remove.bg/"
  spec.license = "MIT"
  spec.metadata["source_code_uri"] = "https://github.com/remove-bg/ruby"
  spec.metadata["changelog_uri"] = "https://github.com/remove-bg/ruby/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|examples)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 0.14", "< 2"

  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "rspec-with_params"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

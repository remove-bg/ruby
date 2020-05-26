require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
end

if ENV.key?("UPLOAD_COVERAGE")
  require "codecov"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::SimpleFormatter,
    SimpleCov::Formatter::Codecov
  ])
end

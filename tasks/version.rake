# frozen_string_literal: true

desc "Bump version of this gem"
task :version, [:version] do |_task, args|
  args.with_defaults(version: nil)

  if args[:version].nil?
    puts "Version: #{RemoveBg::VERSION}"
    exit 0
  end

  unless /(\d+)\.(\d+)\.(\d+)/.match?(args[:version])
    puts "#{args[:version]} needs to be a major/minor/patch SemVer version number!"
    exit 1
  end

  version_file_path = "lib/remove_bg/version.rb"
  version_pattern = /VERSION = "(.+)"/

  # Read the current version from file
  content = File.read(version_file_path)

  unless content.match(version_pattern)
    puts "Error in #{version_file_path} file! Cannot determine current version!"
    exit 1
  end

  puts "Setting gem version to #{args[:version]}..."
  File.open(version_file_path, "w") do |file|
    file.puts content.sub(version_pattern, %(VERSION = "#{args[:version]}"))
  end

  puts "Version set to #{args[:version]}"
end

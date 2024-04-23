desc "Bump version of this gem"
task :version, [:version] do |_task, args|
  args.with_defaults(version: nil)

  if args[:version].nil?
    puts "Version: #{RemoveBg::VERSION}"
    exit 0
  end

  unless args[:version].match(/(\d+)\.(\d+)\.(\d+)/)
    puts "#{args[:version]} needs to be a major/minor/patch SemVer version number!"
    exit 1
  end

  version_file_path = 'lib/remove_bg/version.rb'
  version_pattern = /VERSION = "(.+)"/

  # Read the current version from file
  content = File.read(version_file_path)
  current_version = content.match(version_pattern)

  unless current_version = content.match(version_pattern)
    puts "Error in #{version_file_path} file! Cannot determine current version!"
    exit 1
  end

  puts "Setting gem version to #{args[:version]}..."
  new_content = content.sub(version_pattern, %Q{VERSION = "#{args[:version]}"})

  File.open(version_file_path, 'w') { |file| file.puts new_content }

  puts "Version set to #{args[:version]}"
end

require "fileutils"
require "forwardable"
require "zip"
require_relative "error"
require_relative "image_composer"

module RemoveBg
  class Result
    extend ::Forwardable

    attr_reader :metadata, :rate_limit

    def_delegators :metadata, :type, :width, :height, :credits_charged

    def initialize(download:, metadata:, rate_limit:)
      @download = download
      @metadata = metadata
      @rate_limit = rate_limit
    end

    def save(file_path, overwrite: false)
      if File.exist?(file_path) && !overwrite
        raise FileOverwriteError.new(file_path)
      end

      FileUtils.cp(image_file, file_path)
    end

    def data
      image_file.rewind
      image_file.read
    end

    private

    attr_reader :download

    def image_file
      download
    end
  end
end

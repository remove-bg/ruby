require "fileutils"
require "forwardable"
require "zip"
require_relative "error"
require_relative "image_composer"

module RemoveBg
  # Provides convenience methods to save the processed image, read the image data,
  # and access metadata such as the image height/width and credits charged.
  #
  class Result
    extend ::Forwardable

    # @return [RemoveBg::ResultMetadata]
    attr_reader :metadata

    # @return [RemoveBg::RateLimitInfo]
    attr_reader :rate_limit

    def_delegators :metadata, :type, :width, :height, :credits_charged

    def initialize(download:, metadata:, rate_limit:)
      @download = download
      @metadata = metadata
      @rate_limit = rate_limit
    end

    # Saves the processed image to the path specified
    # @param file_path [string]
    # @param overwrite [boolean] Overwrite any existing file at the specified path
    # @return [nil]
    #
    def save(file_path, overwrite: false)
      if File.exist?(file_path) && !overwrite
        raise FileOverwriteError.new(file_path)
      end

      FileUtils.cp(image_file, file_path)
    end

    # Returns the binary data of the processed image
    # @return [String]
    #
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

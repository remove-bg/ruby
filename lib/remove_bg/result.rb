require "fileutils"
require "zip"
require_relative "error"
require_relative "image_composer"

module RemoveBg
  class Result
    attr_reader :type, :width, :height, :credits_charged

    def initialize(download:, type:, width:, height:, credits_charged:)
      @download = download
      @type = type
      @width = width
      @height = height
      @credits_charged = credits_charged
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

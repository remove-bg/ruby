require "fileutils"
require_relative "error"

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

      FileUtils.cp(download, file_path)
    end

    def data
      download.rewind
      download.read
    end

    private

    attr_reader :download
  end
end

# frozen_string_literal: true

require "faraday"
require_relative "error"

module RemoveBg
  class Upload
    def self.for_file(file_path)
      raise RemoveBg::FileMissingError.new(file_path) unless File.exist?(file_path)

      content_type = determine_content_type(file_path)
      FARADAY_FILE.new(file_path, content_type)
    end

    def self.determine_content_type(file_path)
      case File.extname(file_path).downcase
      when ".jpg", ".jpeg" then "image/jpeg"
      when ".png" then "image/png"
      else
        raise RemoveBg::Error, "Unsupported file type (#{file_path})"
      end
    end

    private_class_method :determine_content_type

    # UploadIO for Faraday < 0.16.0, Faraday::FilePart for 1.x and File for 2.x
    FARADAY_FILE = if defined?(Faraday::FilePart)
                     Faraday::FilePart
                   elsif defined?(Faraday::UploadIO)
                     Faraday::UploadIO
                   else
                     File
                   end
    private_constant :FARADAY_FILE
  end
end

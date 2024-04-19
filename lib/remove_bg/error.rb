# frozen_string_literal: true

module RemoveBg
  class Error < StandardError; end

  class HttpError < Error
    # @return [Faraday::Response]
    attr_reader :http_response

    # @return [String]
    attr_reader :http_response_body

    def initialize(message, http_response, http_response_body)
      @http_response = http_response
      @http_response_body = http_response_body
      super(message)
    end
  end

  # Raised for all HTTP 4XX errors
  class ClientHttpError < HttpError; end

  # Raised for all HTTP 5XX errors
  class ServerHttpError < HttpError; end

  # Raised for HTTP 429 status code
  class RateLimitError < ClientHttpError
    attr_reader :rate_limit

    def initialize(message, http_response, http_response_body, rate_limit)
      @rate_limit = rate_limit
      super(message, http_response, http_response_body)
    end
  end

  class FileError < Error
    attr_reader :file_path

    def initialize(message, file_path)
      @file_path = file_path
      super(message)
    end
  end

  class FileMissingError < FileError
    def initialize(file_path)
      super("The file doesn't exist: '#{file_path}'", file_path)
    end
  end

  class FileOverwriteError < FileError
    def initialize(file_path)
      super("The file already exists: '#{file_path}' (use #save! or #save_zip! to overwrite existing files)", file_path)
    end
  end

  class InvalidUrlError < Error
    attr_reader :url

    def initialize(url)
      @url = url
      super("Invalid URL: #{url.inspect}")
    end
  end
end

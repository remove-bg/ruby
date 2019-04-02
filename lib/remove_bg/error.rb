module RemoveBg
  class Error < StandardError; end

  class HttpError < Error
    attr_reader :http_response

    def initialize(message, http_response)
      @http_response = http_response
      super(message)
    end
  end

  class ClientHttpError < HttpError; end
  class ServerHttpError < HttpError; end

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
      super("The file already exists: '#{file_path}' (specify #save(overwrite: true) to ignore)", file_path)
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

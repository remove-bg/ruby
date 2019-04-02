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
    attr_reader :filepath

    def initialize(message, filepath)
      @filepath = filepath
      super(message)
    end
  end

  class FileMissingError < FileError
    def initialize(filepath)
      super("The file doesn't exist: '#{filepath}'", filepath)
    end
  end

  class FileOverwriteError < FileError
    def initialize(filepath)
      super("The file already exists: '#{filepath}' (specify #save(overwrite: true) to ignore)", filepath)
    end
  end
end

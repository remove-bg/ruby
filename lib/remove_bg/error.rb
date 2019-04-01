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

  class FileExistsError < Error
    attr_reader :filepath

    def initialize(filepath)
      @filepath = filepath
      super("The file already exists: #{filepath}")
    end
  end
end

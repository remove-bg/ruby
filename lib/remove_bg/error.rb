module RemoveBg
  class Error < StandardError
  end

  class HttpError < Error
    attr_reader :http_response

    def initialize(message, http_response)
      @http_response = http_response
      super(message)
    end
  end
end

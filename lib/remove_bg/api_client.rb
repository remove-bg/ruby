require "faraday"
require "json"
require_relative "api"
require_relative "error"
require_relative "result"
require_relative "upload"
require_relative "version"

module RemoveBg
  class ApiClient
    include RemoveBg::Api

    def initialize(api_url = API_URL, http_options = HTTP_OPTIONS)
      retry_options = {
        max: 2,
        interval: 0.2,
        backoff_factor: 2,
        methods: [:post],
        exceptions: Faraday::Request::Retry::DEFAULT_EXCEPTIONS +
          [Faraday::ConnectionFailed]
      }

      @connection = Faraday.new(api_url, **http_options) do |f|
        f.request :multipart
        f.request :url_encoded
        f.request :retry, retry_options
        f.adapter :net_http
      end
    end

    def remove_from_file(image_path, options)
      data = options.data.merge(image_file: Upload.for_file(image_path))
      request_remove_bg(data, options.api_key)
    end

    def remove_from_url(image_url, options)
      data = options.data.merge(image_url: image_url)
      request_remove_bg(data, options.api_key)
    end

    private

    USER_AGENT = "remove-bg-ruby-#{RemoveBg::VERSION}"
    private_constant :USER_AGENT

    HTTP_OPTIONS = { headers: { "User-Agent" => USER_AGENT } }
    private_constant :HTTP_OPTIONS

    attr_reader :connection

    def request_remove_bg(data, api_key)
      response = connection.post(V1_REMOVE_BG, data) do |req|
        req.headers[HEADER_API_KEY] = api_key
      end

      case response.status
      when 200
        parse_result(response)
      when 400..499
        error_message = parse_error_message(response)
        raise RemoveBg::ClientHttpError.new(error_message, response)
      when 500..599
        error_message = parse_error_message(response)
        raise RemoveBg::ServerHttpError.new(error_message, response)
      else
        raise RemoveBg::HttpError.new("An unknown error occurred", response)
      end
    end

    def parse_result(response)
      RemoveBg::Result.new(
        data: response.body,
        width: response.headers[HEADER_WIDTH]&.to_i,
        height: response.headers[HEADER_HEIGHT]&.to_i,
        credits_charged: response.headers[HEADER_CREDITS_CHARGED]&.to_i,
      )
    end

    def parse_error_message(response)
      parse_errors(response).first["title"]
    end

    def parse_errors(response)
      JSON.parse(response.body)["errors"] || []
    rescue JSON::ParserError
      [{ "title" => "Unable to parse response" }]
    end
  end
end

require "faraday"
require "json"
require_relative "error"
require_relative "result"
require_relative "upload"

module RemoveBg
  class ApiClient
    DEFAULT_API_URL = "https://api.remove.bg"
    HTTP_OPTIONS = {
      headers: { "User-Agent" => "remove-bg-ruby-#{RemoveBg::VERSION}" }
    }

    def initialize(api_url = DEFAULT_API_URL, http_options = HTTP_OPTIONS)
      @connection = Faraday.new(api_url, **http_options) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter :net_http
      end
    end

    def remove_from_file(image_path, api_key)
      data = {
        image_file: Upload.for_file(image_path),
        size: "auto",
      }

      request_remove_bg(data, api_key)
    end

    def remove_from_url(image_url, api_key)
      data = {
        image_url: image_url,
        size: "auto",
      }

      request_remove_bg(data, api_key)
    end

    private

    attr_reader :connection

    V1_REMOVE_BG = "/v1.0/removebg"
    private_constant :V1_REMOVE_BG

    HEADER_API_KEY = "X-Api-Key"
    private_constant :HEADER_API_KEY

    HEADER_WIDTH = "X-Width"
    private_constant :HEADER_WIDTH

    HEADER_HEIGHT = "X-Height"
    private_constant :HEADER_HEIGHT

    HEADER_CREDITS_CHARGED = "X-Credits-Charged"
    private_constant :HEADER_CREDITS_CHARGED

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

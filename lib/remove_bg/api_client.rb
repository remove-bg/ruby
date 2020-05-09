require "json"
require "tempfile"

require_relative "account_info"
require_relative "api"
require_relative "error"
require_relative "http_connection"
require_relative "result"
require_relative "upload"
require_relative "url_validator"

module RemoveBg
  class ApiClient
    include RemoveBg::Api

    def initialize(connection: RemoveBg::HttpConnection.build)
      @connection = connection
    end

    def remove_from_file(image_path, options)
      data = options.data.merge(image_file: Upload.for_file(image_path))
      request_remove_bg(data, options.api_key)
    end

    def remove_from_url(image_url, options)
      RemoveBg::UrlValidator.validate(image_url)
      data = options.data.merge(image_url: image_url)
      request_remove_bg(data, options.api_key)
    end

    def account_info(options)
      request_account_info(options.api_key)
    end

    private

    attr_reader :connection

    def request_remove_bg(data, api_key)
      download = Tempfile.new("remove-bg-download")

      response = connection.post(V1_REMOVE_BG, data) do |req|
        req.headers[HEADER_API_KEY] = api_key
        req.options.on_data = Proc.new do |chunk, _|
          download.write(chunk)
        end
      end

      download.rewind

      if response.status == 200
        parse_image_result(headers: response.headers, download: download)
      else
        response_body = download.read
        download.close
        download.unlink
        handle_http_error(response: response, body: response_body)
      end
    end

    def request_account_info(api_key)
      response = connection.get(V1_ACCOUNT) do |req|
        req.headers[HEADER_API_KEY] = api_key
      end

      if response.status == 200
        parse_account_result(response)
      else
        handle_http_error(response: response, body: response.body)
      end
    end

    def handle_http_error(response:, body:)
      case response.status
      when 400..499
        error_message = parse_error_message(body)
        raise RemoveBg::ClientHttpError.new(error_message, response, body)
      when 500..599
        error_message = parse_error_message(body)
        raise RemoveBg::ServerHttpError.new(error_message, response, body)
      else
        raise RemoveBg::HttpError.new("An unknown error occurred", response, body)
      end
    end

    def parse_image_result(headers:, download:)
      RemoveBg::Result.new(
        download: download,
        type: headers[HEADER_TYPE],
        width: headers[HEADER_WIDTH]&.to_i,
        height: headers[HEADER_HEIGHT]&.to_i,
        credits_charged: headers[HEADER_CREDITS_CHARGED]&.to_f,
      )
    end

    def parse_account_result(response)
      attributes = JSON.parse(response.body, symbolize_names: true)
        .fetch(:data)
        .fetch(:attributes)

      RemoveBg::AccountInfo.new(attributes)
    end

    def parse_error_message(response_body)
      parse_errors(response_body).first["title"]
    end

    def parse_errors(response_body)
      JSON.parse(response_body)["errors"] || []
    rescue JSON::ParserError
      [{ "title" => "Unable to parse response" }]
    end
  end
end

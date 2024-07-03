# frozen_string_literal: true

require "json"
require "tempfile"

require_relative "account_info"
require_relative "api"
require_relative "composite_result"
require_relative "error"
require_relative "http_connection"
require_relative "rate_limit_info"
require_relative "result_metadata"
require_relative "result"
require_relative "upload"
require_relative "url_validator"

module RemoveBg
  class ApiClient
    include RemoveBg::Api

    # @param connection [Faraday::Connection]
    #
    def initialize(connection: RemoveBg::HttpConnection.build)
      @connection = connection
    end

    # Removes the background from an image on the local file system
    # @param image_path [String]
    # @param options [RemoveBg::RequestOptions]
    # @return [RemoveBg::Result|RemoveBg::CompositeResult]
    # @raise [RemoveBg::Error]
    #
    def remove_from_file(image_path, options)
      data = options.data.merge(image_file: Upload.for_file(image_path))
      request_remove_bg(data, options.api_key)
    end

    # Removes the background from the image at the URL specified
    # @param image_url [String]
    # @param options [RemoveBg::RequestOptions]
    # @return [RemoveBg::Result|RemoveBg::CompositeResult]
    # @raise [RemoveBg::Error]
    #
    def remove_from_url(image_url, options)
      RemoveBg::UrlValidator.validate(image_url)
      data = options.data.merge(image_url: image_url)
      request_remove_bg(data, options.api_key)
    end

    # Fetches account information
    # @param options [RemoveBg::BaseRequestOptions]
    # @return [RemoveBg::AccountInfo]
    # @raise [RemoveBg::Error]
    #
    def account_info(options)
      request_account_info(options.api_key)
    end

    private

    attr_reader :connection

    def request_remove_bg(data, api_key)
      download = Tempfile.new("remove-bg-download")
      download.binmode

      streaming = false

      response = connection.post(V1_REMOVE_BG, data) do |req|
        req.headers[HEADER_API_KEY] = api_key

        # Faraday v0.16 & v1.0+ support streaming, v0.17 did not (rollback release)
        if req.options.respond_to?(:on_data)
          streaming = true
          req.options.on_data = proc do |chunk, _|
            download.write(chunk)
          end
        end
      end

      # Faraday v0.17
      download.write(response.body) unless streaming

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
      error_message = parse_error_message(body)

      case response.status
      when 429
        rate_limit = RateLimitInfo.new(response.headers)
        raise RemoveBg::RateLimitError.new(error_message, response, body, rate_limit)
      when 400..499
        raise RemoveBg::ClientHttpError.new(error_message, response, body)
      when 500..599
        raise RemoveBg::ServerHttpError.new(error_message, response, body)
      else
        raise RemoveBg::HttpError.new("An unknown error occurred", response, body)
      end
    end

    def parse_image_result(headers:, download:)
      result_for_content_type(headers["Content-Type"]).new(
        download: download,
        metadata: ResultMetadata.new(headers),
        rate_limit: RateLimitInfo.new(headers)
      )
    end

    def result_for_content_type(content_type)
      if content_type&.include?("application/zip")
        CompositeResult
      else
        Result
      end
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

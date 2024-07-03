# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require_relative "api"
require_relative "version"

module RemoveBg
  class HttpConnection
    USER_AGENT = "remove-bg-ruby-#{RemoveBg::VERSION}"
    HTTP_BASE_TIMEOUT = 20
    HTTP_WRITE_TIMEOUT = 120

    # @return [Faraday::Connection]
    #
    def self.build(api_url = RemoveBg::Api::URL)
      retry_options = {
        max: 2,
        interval: 0.2,
        backoff_factor: 2,
        methods: [:post],
        exceptions: Faraday::Retry::Middleware::DEFAULT_EXCEPTIONS + [Faraday::ConnectionFailed],
      }

      request_options = Faraday::RequestOptions.new.tap do |req_options|
        req_options.timeout = HTTP_BASE_TIMEOUT
        req_options.open_timeout = HTTP_BASE_TIMEOUT
        req_options.write_timeout = HTTP_WRITE_TIMEOUT
      end

      http_options = {
        headers: { "User-Agent" => USER_AGENT },
        request: request_options,
      }

      Faraday.new(api_url, http_options) do |f|
        f.request :multipart
        f.request :url_encoded
        f.request :retry, retry_options
        f.adapter :net_http
      end
    end
  end
end

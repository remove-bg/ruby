require "faraday"
require_relative "api"
require_relative "version"

module RemoveBg
  class HttpConnection
    USER_AGENT = "remove-bg-ruby-#{RemoveBg::VERSION}"
    private_constant :USER_AGENT

    def self.build(api_url = RemoveBg::Api::URL)
      retry_options = {
        max: 2,
        interval: 0.2,
        backoff_factor: 2,
        methods: [:post],
        exceptions: Faraday::Request::Retry::DEFAULT_EXCEPTIONS +
          [Faraday::ConnectionFailed]
      }

      request_options = Faraday::RequestOptions.new.tap do |req_options|
        req_options.timeout = 10
        req_options.open_timeout = 10
        req_options.write_timeout = 120
      end

      http_options = {
        headers: { "User-Agent" => USER_AGENT },
        request: request_options,
      }

      Faraday.new(api_url, **http_options) do |f|
        f.request :multipart
        f.request :url_encoded
        f.request :retry, retry_options
        f.adapter :net_http
      end
    end
  end
end

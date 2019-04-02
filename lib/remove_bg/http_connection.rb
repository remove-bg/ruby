require "faraday"
require_relative "api"
require_relative "version"

module RemoveBg
  class HttpConnection
    USER_AGENT = "remove-bg-ruby-#{RemoveBg::VERSION}"
    private_constant :USER_AGENT

    HTTP_OPTIONS = { headers: { "User-Agent" => USER_AGENT } }
    private_constant :HTTP_OPTIONS

    def self.build(api_url = RemoveBg::Api::URL, http_options = HTTP_OPTIONS)
      retry_options = {
        max: 2,
        interval: 0.2,
        backoff_factor: 2,
        methods: [:post],
        exceptions: Faraday::Request::Retry::DEFAULT_EXCEPTIONS +
          [Faraday::ConnectionFailed]
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

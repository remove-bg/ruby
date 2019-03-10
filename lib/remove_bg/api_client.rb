require "faraday"
require "json"
require_relative "error"

module RemoveBg
  class ApiClient
    DEFAULT_API_URL = "https://api.remove.bg"

    def initialize(api_url = DEFAULT_API_URL)
      @connection = Faraday.new(api_url) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter :net_http
      end
    end

    def post_image(image_path, api_key)
      data = {
        image_file: Faraday::UploadIO.new(image_path, "image/jpeg"),
        size: "auto",
      }

      response = connection.post(V1_REMOVE_BG, data) do |req|
        req.headers[HEADER_API_KEY] = api_key
      end

      if response.status == 403
        error_message = parse_errors(response).first["title"]
        raise RemoveBg::HttpError.new(error_message, response)
      end

      response
    end

    private

    attr_reader :connection

    V1_REMOVE_BG = "/v1.0/removebg"
    private_constant :V1_REMOVE_BG

    HEADER_API_KEY = "X-Api-Key"
    private_constant :HEADER_API_KEY

    def parse_errors(response)
      JSON.parse(response.body)["errors"] || []
    end
  end
end

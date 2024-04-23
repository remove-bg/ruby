# frozen_string_literal: true

RSpec.describe RemoveBg::ApiClient do
  subject(:api_client) { described_class.new }

  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  context "with an invalid API key" do
    let(:request_options) { build_options(api_key: "invalid-api-key") }

    it "raises an error with a helpful message" do
      make_request = proc do
        VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
          api_client.remove_from_file(image_path, request_options)
        end
      end

      expect(&make_request).to raise_error RemoveBg::HttpError, /API Key invalid/
    end

    it "includes the HTTP response for further debugging" do
      make_request = proc do
        VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
          api_client.remove_from_file(image_path, request_options)
        end
      end

      expect(&make_request).to raise_error RemoveBg::HttpError do |exception|
        expect(exception.http_response).to be_a Faraday::Response
      end
    end
  end

  context "with invalid image URL" do
    it "raises an error" do
      expect { api_client.remove_from_url("", build_options) }
        .to raise_error RemoveBg::InvalidUrlError
    end
  end

  context "when rate limit exceeded", :disable_vcr do
    let(:request) do
      proc { api_client.remove_from_file(image_path, build_options) }
    end

    it "raises a specific error, to aid rate limit implementations" do
      stub_request(:post, /api.remove.bg/).to_return(
        status: 429,
        body: '{ "errors": [{"title": "Rate limit exceeded"}] }',
      )

      expect(&request).to raise_error RemoveBg::RateLimitError, "Rate limit exceeded"
    end

    it "includes the parsed rate limit information" do
      moment = Time.now.utc

      stub_request(:post, /api.remove.bg/).to_return(
        status: 429,
        headers: {
          "X-RateLimit-Limit" => "500",
          "X-RateLimit-Remaining" => "0",
          "X-RateLimit-Reset" => moment.to_i,
          "Retry-After" => "32",
        }
      )

      expect(&request).to raise_error RemoveBg::RateLimitError do |ex|
        rate_limit = ex.rate_limit

        expect(rate_limit.total).to eq 500
        expect(rate_limit.remaining).to eq 0
        expect(rate_limit.reset_at).to be_within(1).of(moment)
        expect(rate_limit.retry_after_seconds).to eq 32
      end
    end
  end

  describe "with a non-JSON response" do
    it "raises a server error", :disable_vcr do
      stub_request(:post, /api.remove.bg/).to_return(
        body: "<html>Bad gateway</html>",
        status: 502,
        headers: { "Content-Type" => "text/html" },
      )

      make_request = proc do
        api_client.remove_from_url("http://example.image.jpg", build_options)
      end

      expect(&make_request).to raise_error do |exception|
        expect(exception).to be_a(RemoveBg::ServerHttpError)
        expect(exception.message).to eq "Unable to parse response"
        expect(exception.http_response_body).to include "Bad gateway"
      end
    end
  end

  describe "when a response has no content" do
    it "raises an error", :disable_vcr do
      stub_request(:post, /api.remove.bg/).to_return(status: 204)

      make_request = proc do
        api_client.remove_from_url("http://example.image.jpg", build_options)
      end

      expect(&make_request).to raise_error RemoveBg::HttpError, /unknown error/
    end
  end

  describe "client version" do
    it "is included in the request", :disable_vcr do
      stub_request(:post, /api.remove.bg/).to_return(status: 200, body: "")

      api_client.remove_from_url("http://example.image.jpg", build_options)

      expect(WebMock).to have_requested(:post, /api.remove.bg/)
        .with(headers: { "User-Agent" => "remove-bg-ruby-#{RemoveBg::VERSION}" })
    end
  end

  describe "retrying a request", :disable_vcr do
    let(:image_url) { "http://example.image.jpg" }

    it "makes 3 attempts in total" do
      stub_request(:post, /api.remove.bg/)
        .to_timeout
        .to_timeout
        .to_return(status: 200, body: "data")

      result = api_client.remove_from_url(image_url, build_options)

      expect(result.data).to eq "data"
    end

    it "stops retrying after the 3rd attempt" do
      stub_request(:post, /api.remove.bg/).to_timeout

      make_request = proc do
        api_client.remove_from_url(image_url, build_options)
      end

      expect(&make_request).to raise_error Faraday::ConnectionFailed
      expect(WebMock).to have_requested(:post, /api.remove.bg/).times(3)
    end
  end

  describe "handling binary data" do
    let(:image_url) { "http://example.image.jpg" }
    let(:response_data) { (+"\xFF").force_encoding(Encoding::BINARY) }

    it "handles the encoding correctly" do
      stub_request(:post, /api.remove.bg/)
        .to_return(status: 200, body: response_data)

      expect(response_data.encoding).to eq(Encoding::BINARY)

      result = api_client.remove_from_url(image_url, build_options)

      expect(result.data.encoding).to eq(Encoding::BINARY)
    end
  end

  describe "#account_info" do
    context "with an invalid API key" do
      it "raises an error with a helpful message" do
        request_options = RemoveBg::BaseRequestOptions.new(api_key: "invalid-api-key")

        make_request = proc do
          VCR.use_cassette("account-invalid-api-key") do
            api_client.account_info(request_options)
          end
        end

        expect(&make_request).to raise_error RemoveBg::HttpError, /API Key invalid/
      end
    end
  end

  private

  def build_options(options = { api_key: "api-key" })
    RemoveBg::RequestOptions.new(options)
  end
end

require "remove_bg"

RSpec.describe RemoveBg::ApiClient do
  describe "with an invalid API key" do
    let(:image_path) do
      File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
    end

    let(:request_options) { build_options(api_key: "invalid-api-key") }

    it "raises an error with a helpful message" do
      make_request = Proc.new do
        VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
          subject.remove_from_file(image_path, request_options)
        end
      end

      expect(make_request).to raise_error RemoveBg::HttpError, /API Key invalid/
    end

    it "includes the HTTP response for further debugging" do
      make_request = Proc.new do
        VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
          subject.remove_from_file(image_path, request_options)
        end
      end

      expect(make_request).to raise_error RemoveBg::HttpError do |exception|
        expect(exception.http_response).to be_a Faraday::Response
      end
    end
  end

  describe "with a non-JSON response" do
    it "raises a server error", :disable_vcr do
      stub_request(:post, %r{api.remove.bg}).to_return(
        body: "<html>Bad gateway</html>",
        status: 502,
        headers: { "Content-Type" => "text/html" },
      )

      make_request = Proc.new do
        subject.remove_from_url("http://example.image.jpg", build_options)
      end

      expect(make_request).to raise_error do |exception|
        expect(exception).to be_a(RemoveBg::ServerHttpError)
        expect(exception.message).to eq "Unable to parse response"
        expect(exception.http_response.body).to include "Bad gateway"
      end
    end
  end

  describe "when a response has no content" do
    it "raises an error", :disable_vcr do
      stub_request(:post, %r{api.remove.bg}).to_return(status: 204)

      make_request = Proc.new do
        subject.remove_from_url("http://example.image.jpg", build_options)
      end

      expect(make_request).to raise_error RemoveBg::HttpError, /unknown error/
    end
  end

  describe "client version" do
    it "is included in the request", :disable_vcr do
      stub_request(:post, %r{api.remove.bg}).to_return(status: 200, body: "")

      subject.remove_from_url("http://example.image.jpg", build_options)

      expect(WebMock).to have_requested(:post, %r{api.remove.bg}).
        with(headers: { "User-Agent" => "remove-bg-ruby-#{RemoveBg::VERSION}" })
    end
  end

  private

  def build_options(options = { api_key: "api-key" })
    RemoveBg::RequestOptions.new(options)
  end
end

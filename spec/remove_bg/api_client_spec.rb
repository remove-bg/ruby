require "remove_bg"

RSpec.describe RemoveBg::ApiClient, "with an invalid API key" do
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "raises an error with a helpful message" do
    make_request = Proc.new do
      VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
        subject.remove_from_file(image_path, "invalid-api-key")
      end
    end

    expect(make_request).to raise_error RemoveBg::HttpError, /API Key invalid/
  end

  it "includes the HTTP response for further debugging" do
    make_request = Proc.new do
      VCR.use_cassette("from-file-person-in-field-invalid-api-key") do
        subject.remove_from_file(image_path, "invalid-api-key")
      end
    end

    expect(make_request).to raise_error RemoveBg::HttpError do |exception|
      expect(exception.http_response).to be_a Faraday::Response
    end
  end
end

RSpec.describe RemoveBg::ApiClient, "with a non-JSON response" do
  it "raises a server error", :disable_vcr do
    stub_request(:post, %r{api.remove.bg}).to_return(
      body: "<html>Bad gateway</html>",
      status: 502,
      headers: { "Content-Type" => "text/html" },
    )

    make_request = Proc.new do
      subject.remove_from_url("http://example.image.jpg", "api-key")
    end

    expect(make_request).to raise_error do |exception|
      expect(exception).to be_a(RemoveBg::ServerHttpError)
      expect(exception.message).to eq "Unable to parse response"
      expect(exception.http_response.body).to include "Bad gateway"
    end
  end
end

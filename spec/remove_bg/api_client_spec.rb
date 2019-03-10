require "remove_bg"

RSpec.describe RemoveBg::ApiClient, "with an invalid API key" do
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "raises an error with a helpful message" do
    make_request = Proc.new do
      VCR.use_cassette("person-in-field-invalid-api-key") do
        RemoveBg.from_file(image_path, "invalid-api-key")
      end
    end

    expect(make_request).to raise_error RemoveBg::HttpError, /API Key invalid/
  end

  it "includes the HTTP response for further debugging" do
    make_request = Proc.new do
      VCR.use_cassette("person-in-field-invalid-api-key") do
        RemoveBg.from_file(image_path, "invalid-api-key")
      end
    end

    expect(make_request).to raise_error RemoveBg::HttpError do |exception|
      expect(exception.http_response).to be_a Faraday::Response
    end
  end
end

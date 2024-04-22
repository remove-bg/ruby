# frozen_string_literal: true

require "remove_bg"

RSpec.describe "removing the background from a URL" do
  let(:api_key) { "test-api-key" }
  let(:image_url) { "https://static.remove.bg/sample-gallery/people/adult-blue-boy-1438275-thumbnail.jpg" }

  it "succeeds with a valid API key" do
    result = VCR.use_cassette("from-url-back-jpg") do
      RemoveBg.from_url(image_url, api_key: api_key)
    end

    expect(result).to be_a RemoveBg::Result
    expect(result.data).to_not be_empty
    expect(result.data.encoding).to eq(Encoding::BINARY)
    expect(result.type).to eq "person"
    expect(result.height).to eq 1080
    expect(result.width).to eq 720
    expect(result.credits_charged).to be_a(Float).and(be >= 0)
  end

  context "image doesn't exist" do
    it "raises an error with a helpful message" do
      make_request = proc do
        VCR.use_cassette("from-url-non-existent-image") do
          RemoveBg.from_url("http://example.com/404.png", api_key: api_key)
        end
      end

      expect(&make_request).to raise_error RemoveBg::ClientHttpError, /Failed to download/
    end
  end
end

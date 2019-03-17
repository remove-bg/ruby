require "remove_bg"

RSpec.describe "removing the background from a URL" do
  let(:api_key) { ENV.fetch("REMOVE_BG_API_KEY") }
  let(:image_url) { "https://www.remove.bg/images/samples/fg/back.jpg" }

  it "succeeds with a valid API key" do
    result = VCR.use_cassette("from-url-back-jpg") do
      RemoveBg.from_url(image_url, api_key)
    end

    expect(result).to be_a_success
    expect(result.headers["content-type"]).to eq "image/png"
    expect(result.body).to_not be_empty
  end
end

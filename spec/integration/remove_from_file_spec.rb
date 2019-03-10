require "remove_bg"

RSpec.describe "removing the background from a file" do
  let(:api_key) { ENV.fetch("REMOVE_BG_API_KEY") }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "succeeds with a valid API key" do
    result = VCR.use_cassette("person-in-field") do
      RemoveBg.from_file(image_path, api_key)
    end

    expect(result).to be_a_success
    expect(result.headers["content-type"]).to eq "image/png"
    expect(result.body).to_not be_empty
  end
end

# frozen_string_literal: true

RSpec.describe "removing the background from a file" do
  let(:api_key) { "test-api-key" }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "succeeds with a valid API key" do
    result = VCR.use_cassette("from-file-person-in-field") do
      RemoveBg.from_file(image_path, api_key:)
    end

    expect(result).to be_a RemoveBg::Result
    expect(result.data).not_to be_empty
    expect(result.data.encoding).to eq(Encoding::BINARY)
    expect(result.type).to eq "person"
    expect(result.height).to eq 333
    expect(result.width).to eq 500
    expect(result.credits_charged).to be_a(Float).and(be >= 0)
  end
end

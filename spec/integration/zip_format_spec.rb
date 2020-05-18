require "remove_bg"
require "digest"

RSpec.describe "using the ZIP format" do
  let(:api_key) { ENV.fetch("REMOVE_BG_API_KEY") }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  before(:each) { RemoveBg::Configuration.reset }

  context "using MiniMagick" do
    it "converts the ZIP to a composite PNG" do
      RemoveBg::Configuration.configuration.image_processor = :minimagick

      result = VCR.use_cassette("zip-person-in-field") do
        RemoveBg.from_file(image_path, format: "zip", api_key: api_key)
      end

      expect(result).to be_a RemoveBg::CompositeResult
      expect(result.data).to start_with("\x89PNG")
      expect(result.height).to eq 333
      expect(result.width).to eq 500
    end
  end

  context "using Vips" do
    it "converts the ZIP to a composite PNG" do
      RemoveBg::Configuration.configuration.image_processor = :vips

      result = VCR.use_cassette("zip-person-in-field") do
        RemoveBg.from_file(image_path, format: "zip", api_key: api_key)
      end

      expect(result).to be_a RemoveBg::CompositeResult
      expect(result.data).to start_with("\x89PNG")
      expect(result.height).to eq 333
      expect(result.width).to eq 500
    end
  end
end

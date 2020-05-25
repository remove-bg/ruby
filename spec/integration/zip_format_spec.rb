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

      expect(result).to be_a_composite_result
      expect(result.data.encoding).to eq(Encoding::BINARY)
      expect(result.data).to be_a_binary_png
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

      expect(result).to be_a_composite_result
      expect(result.data.encoding).to eq(Encoding::BINARY)
      expect(result.data).to be_a_binary_png
      expect(result.height).to eq 333
      expect(result.width).to eq 500
    end
  end

  describe "upgrading PNG requests to ZIP to save bandwidth" do
    it "automatically upgrades the format when image processing is configured" do
      RemoveBg::Configuration.configuration.image_processor = :minimagick

      result = VCR.use_cassette("zip-upgrade") do
        RemoveBg.from_file(image_path, format: "png", api_key: api_key)
      end

      expect(result).to be_a_composite_result
    end

    it "skips the automatic upgrade there is no image processor" do
      RemoveBg::Configuration.configuration.image_processor = nil

      result = VCR.use_cassette("no-zip-upgrade") do
        RemoveBg.from_file(image_path, format: "png", api_key: api_key)
      end

      expect(result).to be_a_plain_result
    end

    it "can be explicitly turned off" do
      RemoveBg::Configuration.configuration.image_processor = :minimagick
      RemoveBg::Configuration.configuration.save_bandwidth = false

      result = VCR.use_cassette("zip-upgrade-off") do
        RemoveBg.from_file(image_path, format: "png", api_key: api_key)
      end

      expect(result).to be_a_plain_result
    end
  end

  private

  def be_a_composite_result
    be_an_instance_of(RemoveBg::CompositeResult)
  end

  def be_a_plain_result
    be_an_instance_of(RemoveBg::Result)
  end

  def be_a_binary_png
    start_with("\x89PNG".force_encoding(Encoding::BINARY))
  end
end

# frozen_string_literal: true

RSpec.describe RemoveBg::Configuration do
  before do
    described_class.reset
  end

  describe "::configure" do
    it "provides a convenient way to update configuration" do
      RemoveBg.configure do |config|
        config.api_key = "an-api-key"
      end

      expect(described_class.configuration.api_key).to eq "an-api-key"
    end
  end

  it "can be reset easily" do
    RemoveBg.configure do |config|
      config.api_key = "an-api-key"
    end

    expect { described_class.reset }
      .to change { described_class.configuration.api_key }
      .from("an-api-key").to(nil)
  end

  describe "image processor" do
    it "is automatically configured if there's processing library available" do
      expect(described_class.configuration.image_processor).to eq :minimagick
    end

    it "can be overridden" do
      RemoveBg.configure do |config|
        config.image_processor = :vips
      end

      expect(described_class.configuration.image_processor).to eq :vips
    end
  end
end

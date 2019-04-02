require "remove_bg"

RSpec.describe RemoveBg::RequestOptions do
  it "has sensible defaults" do
    options = described_class.new(api_key: "xyz")

    expect(options.size).to eq described_class::SIZE_DEFAULT
    expect(options.type).to eq described_class::FOREGROUND_TYPE_DEFAULT
    expect(options.channels).to eq described_class::CHANNELS_DEFAULT
  end

  context "invalid API key configuration" do
    before(:each) { RemoveBg::Configuration.reset }

    it "raises an error if neither global or per-request API key is set" do
      RemoveBg.configure { |config| config.api_key = nil }

      expect{ described_class.new({}) }.
      to raise_error RemoveBg::Error, /configure an API key/
    end

    it "raises an error if the API key is empty" do
      RemoveBg.configure { |config| config.api_key = nil }

      expect{ described_class.new(api_key: "") }.
      to raise_error RemoveBg::Error, /configure an API key/
    end
  end
end

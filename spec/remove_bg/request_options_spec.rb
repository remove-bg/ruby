require "remove_bg"

RSpec.describe RemoveBg::RequestOptions do
  describe "size options" do
    it "defaults the size to 'auto'" do
      request_options = described_class.new(api_key: "xyz").data
      expect(request_options[:size]).to eq described_class::FOREGROUND_TYPE_AUTO
    end

    it "allows the size to be overriden" do
      request_options = described_class.new(api_key: "xyz", size: "4k").data
      expect(request_options[:size]).to eq "4k"
    end
  end

  it "forwards extra parameters for future flexibility" do
    request_options = described_class.new(api_key: "xyz", foo: "bar").data
    expect(request_options[:foo]).to eq "bar"
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

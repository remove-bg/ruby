require "remove_bg"

RSpec.describe "Remove BG configuration"  do
  before(:each) { RemoveBg::Configuration.reset }

  describe "::configure" do
    it "provides a convenient way to update configuration" do
      RemoveBg.configure do |config|
        config.api_key = "an-api-key"
      end

      expect(RemoveBg::Configuration.configuration.api_key).to eq "an-api-key"
    end
  end

  it "can be reset easily" do
    RemoveBg.configure do |config|
      config.api_key = "an-api-key"
    end

    expect{ RemoveBg::Configuration.reset }.
      to change{ RemoveBg::Configuration.configuration.api_key }.
      from("an-api-key").to(nil)
  end
end

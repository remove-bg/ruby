require "remove_bg"

RSpec.describe "RemoveBg::from_url" do
  describe "using global API key" do
    before(:each) { RemoveBg::Configuration.reset }

    it "allows the inline API key to omitted" do
      api_key = "an-api_key"
      image_url = "http:://example.com/image.png"
      api_client = spy_on_api_client

      RemoveBg.configure { |config| config.api_key = api_key }
      RemoveBg.from_url(image_url)

      expect(api_client).
        to have_received(:remove_from_url).with(image_url, api_key)
    end
  end

  private

  def spy_on_api_client
    instance_double(RemoveBg::ApiClient, remove_from_url: nil).tap do |double|
      allow(RemoveBg::ApiClient).to receive(:new).and_return(double)
    end
  end
end

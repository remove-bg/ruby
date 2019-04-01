require "remove_bg"

RSpec.describe "RemoveBg::from_file" do
  describe "using global API key" do
    before(:each) { RemoveBg::Configuration.reset }

    it "allows the inline API key to omitted" do
      api_key = "an-api_key"
      image_path = "image.png"
      api_client = spy_on_api_client

      RemoveBg.configure { |config| config.api_key = api_key }
      RemoveBg.from_file(image_path)

      expect(api_client).
        to have_received(:remove_from_file).with(image_path, api_key)
    end
  end

  private

  def spy_on_api_client
    instance_double(RemoveBg::ApiClient, remove_from_file: nil).tap do |double|
      allow(RemoveBg::ApiClient).to receive(:new).and_return(double)
    end
  end
end

# frozen_string_literal: true

RSpec.describe "RemoveBg::from_file" do # rubocop:disable RSpec/DescribeClass
  let(:image_path) { "image.png" }

  describe "using global API key" do
    before { RemoveBg::Configuration.reset }

    it "allows the inline API key to omitted" do
      api_key = "an-api_key"
      api_client = spy_on_api_client

      RemoveBg.configure { |config| config.api_key = api_key }
      RemoveBg.from_file(image_path)

      expected_request_options = having_attributes(api_key:)

      expect(api_client).to have_received(:remove_from_file)
        .with(image_path, expected_request_options)
    end
  end

  it "allows options to be overriden" do
    options = {
      size: "4k",
      type: "product",
      channels: "alpha",
    }

    api_client = spy_on_api_client
    RemoveBg.from_file(image_path, options.merge({ api_key: "an-api-key" }))

    expect(api_client).to have_received(:remove_from_file)
      .with(anything, satisfy { |arg| arg.data == options })
  end

  private

  def spy_on_api_client
    instance_double(RemoveBg::ApiClient, remove_from_file: nil).tap do |double|
      allow(RemoveBg::ApiClient).to receive(:new).and_return(double)
    end
  end
end

require "remove_bg/configuration"
require "remove_bg/image_composer"

RSpec.describe RemoveBg::ImageComposer do
  before(:each) { RemoveBg::Configuration.reset }

  let(:alpha_file) { instance_double(File, "alpha") }
  let(:color_file) { instance_double(File, "color") }
  let(:destination_path) { double("Destination path") }

  it "uses MiniMagick by default" do
    processing_spy = spy_on_image_processing(ImageProcessing::MiniMagick)

    perform_composition

    expect(processing_spy).to have_received(:call).with(destination: destination_path)
  end

  context "configured to use Vips" do
    it "uses Vips" do
      RemoveBg::Configuration.configuration.image_processor = :vips

      processing_spy = spy_on_image_processing(ImageProcessing::Vips)

      perform_composition

      expect(processing_spy).to have_received(:call).with(destination: destination_path)
    end
  end

  private

  def spy_on_image_processing(klass)
    spy(klass.to_s).tap do |processing_spy|
      allow(klass).to receive(:source).and_return(processing_spy)
    end
  end

  def perform_composition
    subject.compose(
      color_file: color_file,
      alpha_file: alpha_file,
      destination_path: destination_path
    )
  end
end

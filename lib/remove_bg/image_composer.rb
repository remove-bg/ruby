require_relative "error"

module RemoveBg
  class ImageComposer
    DEFAULT_BINARY_DETECTOR = lambda do |binary_name|
      system("which", binary_name, out: File::NULL)
    end

    def self.detect_image_processor(detector: DEFAULT_BINARY_DETECTOR)
      case
      when detector.call("magick"), detector.call("convert"), detector.call("gm")
        :minimagick
      when detector.call("vips")
        :vips
      end
    end

    def compose(color_file:, alpha_file:, destination_path:)
      image = case configured_image_processor
        when :vips
          then vips_compose(color_file: color_file, alpha_file: alpha_file)
        when :minimagick
          then minimagick_compose(color_file: color_file, alpha_file: alpha_file)
        when nil
          raise RemoveBg::Error, "Please configure an image processor to use image composition"
        else
          raise RemoveBg::Error, "Unsupported image processor: #{configured_image_processor.inspect}"
        end

      image.call(destination: destination_path)
    end

    private

    def configured_image_processor
      RemoveBg::Configuration.configuration.image_processor
    end

    def minimagick_compose(color_file:, alpha_file:)
      require "image_processing/mini_magick"

      ImageProcessing::MiniMagick
        .source(color_file)
        .composite(alpha_file, mode: "copy-opacity")
    end

    def vips_compose(color_file:, alpha_file:)
      require "image_processing/vips"

      ImageProcessing::Vips
        .source(color_file)
        .custom { |image| image.bandjoin(Vips::Image.new_from_file(alpha_file.path)) }
    end
  end
end

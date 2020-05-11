require "image_processing/mini_magick"
require "image_processing/vips"

module RemoveBg
  class ImageComposer
    def compose(color_file:, alpha_file:, destination_path:)
      image = case configured_image_processor
        when :vips
          then vips_compose(color_file: color_file, alpha_file: alpha_file)
        when :minimagick
          then minimagick_compose(color_file: color_file, alpha_file: alpha_file)
        else
          raise "Unsupported image processor: #{configured_image_processor.inspect}"
        end

      image.call(destination: destination_path)
    end

    private

    def configured_image_processor
      RemoveBg::Configuration.configuration.image_processor
    end

    def minimagick_compose(color_file:, alpha_file:)
      ImageProcessing::MiniMagick
        .source(color_file)
        .composite(alpha_file, mode: "copy-opacity")
    end

    def vips_compose(color_file:, alpha_file:)
      ImageProcessing::Vips
        .source(color_file)
        .custom { |image| image.bandjoin(Vips::Image.new_from_file(alpha_file.path)) }
    end
  end
end

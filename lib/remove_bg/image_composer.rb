require "image_processing/mini_magick"

module RemoveBg
  class ImageComposer
    def compose(color_file:, alpha_file:, destination_path:)
      ImageProcessing::MiniMagick
        .source(color_file)
        .composite(alpha_file, mode: "copy-opacity")
        .call(destination: destination_path)
    end
  end
end

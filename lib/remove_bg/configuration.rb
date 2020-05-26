require_relative "image_composer"

module RemoveBg
  class Configuration
    attr_accessor :api_key, :image_processor, :auto_upgrade_png_to_zip

    def self.configuration
      @configuration ||= Configuration.new.tap do |config|
        config.image_processor = ImageComposer.detect_image_processor

        # Upgrade to ZIP where possible to save bandwith
        config.auto_upgrade_png_to_zip = true
      end
    end

    def self.reset
      @configuration = nil
    end

    def can_process_images?
      !image_processor.nil?
    end
  end
end

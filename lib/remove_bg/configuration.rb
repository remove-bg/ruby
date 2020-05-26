require_relative "image_composer"

module RemoveBg
  class Configuration
    attr_accessor :api_key, :image_processor, :save_bandwidth

    def self.configuration
      @configuration ||= Configuration.new.tap do |config|
        config.image_processor = ImageComposer.detect_image_processor

        # Upgrade to ZIP where possible to save bandwith
        config.save_bandwidth = true
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

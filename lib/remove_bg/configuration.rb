module RemoveBg
  class Configuration
    attr_accessor :api_key, :image_processor

    def initialize(image_processor: :minimagick)
      @image_processor = image_processor
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end
  end
end

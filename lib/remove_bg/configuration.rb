module RemoveBg
  class Configuration
    attr_accessor :api_key, :image_processor

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end
  end
end

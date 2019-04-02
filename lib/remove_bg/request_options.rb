require_relative "error"

module RemoveBg
  class RequestOptions
    SIZE_REGULAR = "regular"
    SIZE_MEDIUM = "medium"
    SIZE_HD = "hd"
    SIZE_4K = "4k"
    SIZE_AUTO = "auto"
    SIZE_DEFAULT = SIZE_AUTO

    FOREGROUND_TYPE_AUTO = "auto"
    FOREGROUND_TYPE_PERSON = "person"
    FOREGROUND_TYPE_PRODUCT = "product"
    FOREGROUND_TYPE_DEFAULT = FOREGROUND_TYPE_AUTO

    CHANNELS_RGBA = "rgba"
    CHANNELS_ALPHA = "alpha"
    CHANNELS_DEFAULT = CHANNELS_RGBA

    attr_reader :api_key, :size, :type, :channels

    def initialize(raw_options = {})
      @api_key = resolve_api_key(raw_options)
      @size = raw_options.fetch(:size, SIZE_DEFAULT)
      @type = raw_options.fetch(:type, FOREGROUND_TYPE_DEFAULT)
      @channels = raw_options.fetch(:channels, CHANNELS_DEFAULT)
    end

    def data
      {
        size: size,
        type: type,
        channels: channels,
      }
    end

    private

    def resolve_api_key(raw_options)
      api_key = raw_options.fetch(:api_key) { global_api_key }

      if api_key.nil? || api_key.empty?
        raise RemoveBg::Error, <<~MSG
          Please configure an API key or specify one per request. API key was:
          #{api_key.inspect}
        MSG
      end

      api_key
    end

    def global_api_key
      RemoveBg::Configuration.configuration.api_key
    end
  end
end

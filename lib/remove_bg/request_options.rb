require_relative "error"

module RemoveBg
  class RequestOptions
    SIZE_REGULAR = "regular"
    SIZE_MEDIUM = "medium"
    SIZE_HD = "hd"
    SIZE_4K = "4k"
    SIZE_AUTO = "auto"

    FOREGROUND_TYPE_AUTO = "auto"
    FOREGROUND_TYPE_PERSON = "person"
    FOREGROUND_TYPE_PRODUCT = "product"

    CHANNELS_RGBA = "rgba"
    CHANNELS_ALPHA = "alpha"

    attr_reader :api_key, :data

    def initialize(raw_options = {})
      options = raw_options.dup
      options[:size] ||= SIZE_AUTO
      @api_key = resolve_api_key(options.delete(:api_key))
      @data = options
    end

    private

    def resolve_api_key(request_api_key)
      api_key = request_api_key || global_api_key

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

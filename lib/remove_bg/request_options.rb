require_relative "base_request_options"

module RemoveBg
  class RequestOptions < BaseRequestOptions
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

    def initialize(raw_options = {})
      options = raw_options.dup
      options[:size] ||= SIZE_AUTO
      super(options)
    end
  end
end

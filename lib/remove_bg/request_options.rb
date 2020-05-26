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

    FORMAT_PNG = "png"
    FORMAT_ZIP = "zip"
    FORMAT_JPG = "jpg"

    def initialize(raw_options = {})
      options = raw_options.dup
      options[:size] ||= SIZE_AUTO

      if options.key?(:format)
        options[:format] = optimize_format(options[:format])
      end

      super(options)
    end

    private

    # Save bandwidth where possible
    def optimize_format(requested_format)
      requested_png = requested_format.to_s.casecmp?(FORMAT_PNG)

      if requested_png && optimization_enabled? && can_process_images?
        FORMAT_ZIP
      else
        requested_format
      end
    end

    def can_process_images?
      RemoveBg::Configuration.configuration.can_process_images?
    end

    def optimization_enabled?
      RemoveBg::Configuration.configuration.auto_upgrade_png_to_zip
    end
  end
end

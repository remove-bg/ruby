require "uri"
require_relative "error"

module RemoveBg
  class UrlValidator
    PERMITTED_SCHEMES = ["http", "https"].freeze

    def self.validate(url)
      parsed = URI.parse(url)

      unless parsed.absolute? && PERMITTED_SCHEMES.include?(parsed.scheme)
        raise RemoveBg::InvalidUrlError.new(url)
      end
    rescue URI::InvalidURIError
      raise RemoveBg::InvalidUrlError.new(url)
    end
  end
end

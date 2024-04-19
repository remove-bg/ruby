# frozen_string_literal: true

require "uri"
require_relative "error"

module RemoveBg
  class UrlValidator
    PERMITTED_SCHEMES = %w[http https].freeze

    def self.validate(url)
      parsed = URI.parse(url)

      raise RemoveBg::InvalidUrlError.new(url) unless parsed.absolute? && PERMITTED_SCHEMES.include?(parsed.scheme)
    rescue URI::InvalidURIError
      raise RemoveBg::InvalidUrlError.new(url)
    end
  end
end

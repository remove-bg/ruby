# frozen_string_literal: true

require "remove_bg/version"
require "remove_bg/api_client"
require "remove_bg/configuration"
require "remove_bg/request_options"

module RemoveBg
  # Removes the background from an image on the local file system
  # @param image_path [String] Path to the input image
  # @param options [Hash<Symbol, Object>] Image processing options (see API docs)
  # @return [RemoveBg::Result|RemoveBg::CompositeResult] a processed image result
  #
  def self.from_file(image_path, raw_options = {})
    options = RemoveBg::RequestOptions.new(raw_options)
    ApiClient.new.remove_from_file(image_path, options)
  end

  # Removes the background from the image at the URL specified
  # @param image_url [String] Absolute URL of the input image
  # @param options [Hash<Symbol, Object>] Image processing options (see API docs)
  # @return [RemoveBg::Result|RemoveBg::CompositeResult] A processed image result
  #
  def self.from_url(image_url, raw_options = {})
    options = RemoveBg::RequestOptions.new(raw_options)
    ApiClient.new.remove_from_url(image_url, options)
  end

  # Fetches account information for the globally configured API key, or a
  # specific API key if provided
  # @param options [Hash<Symbol, Object>]
  # @return [RemoveBg::AccountInfo]
  #
  def self.account_info(raw_options = {})
    options = RemoveBg::BaseRequestOptions.new(raw_options)
    ApiClient.new.account_info(options)
  end

  # Yields the global Remove.bg configuration
  # @yield [RemoveBg::Configuration]
  def self.configure
    yield RemoveBg::Configuration.configuration
  end
end

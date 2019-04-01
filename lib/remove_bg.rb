require "remove_bg/version"
require "remove_bg/api_client"
require "remove_bg/configuration"
require "remove_bg/request_options"

module RemoveBg
  def self.from_file(image_path, raw_options = {})
    options = RemoveBg::RequestOptions.new(raw_options)
    ApiClient.new.remove_from_file(image_path, options)
  end

  def self.from_url(image_url, raw_options = {})
    options = RemoveBg::RequestOptions.new(raw_options)
    ApiClient.new.remove_from_url(image_url, options)
  end

  def self.configure
    yield RemoveBg::Configuration.configuration
  end
end

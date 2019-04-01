require "remove_bg/version"
require "remove_bg/api_client"
require "remove_bg/configuration"

module RemoveBg
  def self.from_file(image_path, api_key = nil)
    api_key ||= RemoveBg::Configuration.configuration.api_key
    ApiClient.new.remove_from_file(image_path, api_key)
  end

  def self.from_url(image_url, api_key = nil)
    api_key ||= RemoveBg::Configuration.configuration.api_key
    ApiClient.new.remove_from_url(image_url, api_key)
  end

  def self.configure
    yield RemoveBg::Configuration.configuration
  end
end

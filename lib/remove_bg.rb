require "remove_bg/version"
require "remove_bg/api_client"

module RemoveBg
  def self.from_file(image_path, api_key)
    ApiClient.new.remove_from_file(image_path, api_key)
  end

  def self.from_url(image_url, api_key)
    ApiClient.new.remove_from_url(image_url, api_key)
  end
end

# frozen_string_literal: true

require_relative "error"

module RemoveBg
  class BaseRequestOptions
    attr_reader :api_key, :data

    def initialize(raw_options = {})
      options = raw_options.dup
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

require_relative "api"

module RemoveBg
  class ResultMetadata
    attr_reader :type, :width, :height, :credits_charged

    def initialize(headers)
      @type = headers["X-Type"]
      @width =  headers["X-Width"]&.to_i
      @height = headers["X-Height"]&.to_i
      @credits_charged = headers["X-Credits-Charged"]&.to_f
    end
  end
end

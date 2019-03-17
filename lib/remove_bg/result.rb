module RemoveBg
  class Result
    attr_reader :data, :width, :height, :credits_charged

    def initialize(data:, width:, height:, credits_charged:)
      @data = data
      @width = width
      @height = height
      @credits_charged = credits_charged
    end
  end
end

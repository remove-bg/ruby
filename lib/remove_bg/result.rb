require_relative "error"

module RemoveBg
  class Result
    attr_reader :data, :width, :height, :credits_charged

    def initialize(data:, width:, height:, credits_charged:)
      @data = data
      @width = width
      @height = height
      @credits_charged = credits_charged
    end

    def save(filepath, overwrite: false)
      if File.exist?(filepath) && !overwrite
        raise FileOverwriteError.new(filepath)
      end

      File.write(filepath, data)
    end
  end
end

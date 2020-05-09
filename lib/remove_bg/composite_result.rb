require_relative "result"

module RemoveBg
  class CompositeResult < Result
    private

    def image_file
      composite_file
    end

    def composite_file
      @composite_file ||= begin
        Tempfile.new(["composed", ".png"]).tap do |file|
          compose_to_file(file)
        end
      end
    end

    def color_file
      @color_file ||= Tempfile.new(["color", ".jpg"])
    end

    def alpha_file
      @alpha_file ||= Tempfile.new(["alpha", ".png"])
    end

    def compose_to_file(destination)
      extract_parts

      ImageComposer.new.compose(
        color_file: color_file,
        alpha_file: alpha_file,
        destination_path: destination.path
      )
    end

    def extract_parts
      Zip::File.open(download) do |zf|
        zf.find_entry("color.jpg").extract(color_file.path) { true }
        zf.find_entry("alpha.png").extract(alpha_file.path) { true }
      end
    end
  end
end

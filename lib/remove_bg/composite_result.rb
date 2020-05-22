require_relative "result"

module RemoveBg
  class CompositeResult < Result
    def save_zip(file_path, overwrite: false)
      if File.exist?(file_path) && !overwrite
        raise FileOverwriteError.new(file_path)
      end

      FileUtils.cp(download, file_path)
    end

    private

    def image_file
      composite_file
    end

    def composite_file
      @composite_file ||= begin
        binary_tempfile(["composed", ".png"])
          .tap { |file| compose_to_file(file) }
      end
    end

    def color_file
      @color_file ||= binary_tempfile(["color", ".jpg"])
    end

    def alpha_file
      @alpha_file ||= binary_tempfile(["alpha", ".png"])
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

    def binary_tempfile(basename)
      Tempfile.new(basename).tap { |file| file.binmode }
    end
  end
end

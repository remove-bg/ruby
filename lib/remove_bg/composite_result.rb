# frozen_string_literal: true

require_relative "result"

module RemoveBg
  # Handles image composition for larger images (over 10MP) where transparency is
  # required.
  # @see RemoveBg::Result
  #
  class CompositeResult < Result
    # Saves the ZIP archive containing the alpha.png and color.jpg files
    # (useful if you want to handle composition yourself)
    # @param file_path [string]
    # @param overwrite [boolean] Overwrite any existing file at the specified path
    # @return [nil]
    #
    def save_zip(file_path, overwrite: false)
      raise FileOverwriteError.new(file_path) if File.exist?(file_path) && !overwrite

      warn("DEPRECATION WARNING: overwrite: true is deprecated and will be removed from remove_bg 2.0 (use save_zip! instead)") if overwrite

      FileUtils.cp(download, file_path)
    end

    # Saves the ZIP archive containing the alpha.png and color.jpg files, overwriting any exisiting files
    # (useful if you want to handle composition yourself)
    # @param file_path [string]
    # @return [nil]
    #
    def save_zip!(file_path)
      FileUtils.cp(download, file_path)
    end

    private

    def image_file
      composite_file
    end

    def composite_file
      @composite_file ||= binary_tempfile(["composed", ".png"])
                          .tap { |file| compose_to_file(file) }
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
        color_file:,
        alpha_file:,
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
      Tempfile.new(basename).tap(&:binmode)
    end
  end
end

require "remove_bg/upload"
require "rspec/with_params/dsl"
require "securerandom"
require "tempfile"

RSpec.describe RemoveBg::Upload do
  extend RSpec::WithParams::DSL

  with_params(
    [:extension,  :expected_content_type],
    [".jpg",      "image/jpeg"],
    [".jpeg",     "image/jpeg"],
    [".png",      "image/png"],
    [".JPG",      "image/jpeg"],
    [".JPEG",     "image/jpeg"],
    [".PNG",      "image/png"],
  ) do
    it "determines the content type from the file extension" do
      upload = upload_for_file(tmp_file(extension))
      expect(upload).to have_content_type expected_content_type
    end
  end

  it "raises an error for unsupported file types" do
    upload_doc = Proc.new do
      upload_for_file(tmp_file(".docx"))
    end

    expect(upload_doc).to raise_error RemoveBg::Error, /Unsupported file type/
  end

  it "raises an error when the file doesn't exist" do
    image_path = "./#{SecureRandom.urlsafe_base64}.png"

    upload_doc = Proc.new do
      upload_for_file(image_path)
    end

    expect(upload_doc).to raise_error RemoveBg::FileMissingError do |ex|
      expect(ex.file_path).to eq image_path
    end
  end

  private

  def upload_for_file(file)
    described_class.for_file(file)
  end

  def tmp_file(extension)
    Tempfile.new(["image", extension])
  end

  RSpec::Matchers.define :have_content_type do |expected|
    match do |actual|
      @actual = actual.content_type
      @actual == expected
    end
  end
end

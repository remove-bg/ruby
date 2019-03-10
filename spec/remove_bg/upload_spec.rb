require "remove_bg/upload"
require "tempfile"

RSpec.describe RemoveBg::Upload do
  it "determines the content type from the file extension" do
    expect(upload_for_file(tmp_file(".jpg"))).to have_content_type "image/jpeg"
    expect(upload_for_file(tmp_file(".jpeg"))).to have_content_type "image/jpeg"
    expect(upload_for_file(tmp_file(".png"))).to have_content_type "image/png"
  end

  it "raises an error for unsupported file types" do
    upload_doc = Proc.new do
      upload_for_file(tmp_file(".docx"))
    end

    expect(upload_doc).to raise_error RemoveBg::Error, /Unsupported file type/
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

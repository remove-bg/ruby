require "remove_bg/result"
require "securerandom"
require "tmpdir"

RSpec.describe RemoveBg::Result, "#save" do
  let(:tmp_dir) { Dir.mktmpdir("remove_bg") }
  let(:file_path) { File.join(tmp_dir, "#{SecureRandom.urlsafe_base64}.txt") }

  it "writes the data to the specified path" do
    expect(File.exist?(file_path)).to be false

    new_result(data: "test-data").save(file_path)

    expect(File.exist?(file_path)).to be true
    expect(File.read(file_path)).to include "test-data"
  end

  it "raises an error if the file already exists" do
    File.write(file_path, "existing-data")

    attempt_overwrite = Proc.new do
      new_result(data: "test-data").save(file_path)
    end

    expect(attempt_overwrite).to raise_error RemoveBg::FileOverwriteError do |ex|
      expect(ex.message).to include "file already exists"
      expect(ex.file_path).to eq file_path
    end

    expect(File.read(file_path)).to include "existing-data"
  end

  it "allows the file to be overwritten" do
    File.write(file_path, "existing-data")

    new_result(data: "test-data").save(file_path, overwrite: true)

    expect(File.read(file_path)).to include "test-data"
  end

  private

  def new_result(data:)
    described_class.new(
      data: data,
      width: nil,
      height: nil,
      credits_charged: nil,
    )
  end
end

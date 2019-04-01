require "remove_bg/result"
require "securerandom"
require "tmpdir"

RSpec.describe RemoveBg::Result, "#save" do
  let(:tmp_dir) { Dir.mktmpdir("remove_bg") }
  let(:filepath) { File.join(tmp_dir, "#{SecureRandom.urlsafe_base64}.txt") }

  it "writes the data to the specified path" do
    expect(File.exist?(filepath)).to be false

    new_result(data: "test-data").save(filepath)

    expect(File.exist?(filepath)).to be true
    expect(File.read(filepath)).to include "test-data"
  end

  it "raises an error if the file already exists" do
    File.write(filepath, "existing-data")

    attempt_overwrite = Proc.new do
      new_result(data: "test-data").save(filepath)
    end

    expect(attempt_overwrite).to raise_error RemoveBg::FileExistsError do |ex|
      expect(ex.message).to include "file already exists"
      expect(ex.filepath).to eq filepath
    end

    expect(File.read(filepath)).to include "existing-data"
  end

  it "allows the file to be overwritten" do
    File.write(filepath, "existing-data")

    new_result(data: "test-data").save(filepath, overwrite: true)

    expect(File.read(filepath)).to include "test-data"
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

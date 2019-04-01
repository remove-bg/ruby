require "remove_bg/request_options"
require "remove_bg/api"

RSpec.describe RemoveBg::RequestOptions do
  it "has sensible defaults" do
    expect(subject.size).to eq described_class::SIZE_DEFAULT
    expect(subject.type).to eq described_class::FOREGROUND_TYPE_DEFAULT
    expect(subject.channels).to eq described_class::CHANNELS_DEFAULT
  end
end

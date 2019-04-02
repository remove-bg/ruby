require "remove_bg/http_connection"

RSpec.describe RemoveBg::HttpConnection do
  let(:options) { described_class.build.options }

  it "has timeouts configured" do
    expect(options.timeout).to eq 10
    expect(options.open_timeout).to eq 10
    expect(options.write_timeout).to eq 120
  end
end

# frozen_string_literal: true

RSpec.describe "rate limit information" do
  let(:api_key) { "test-api-key" }
  let(:image_path) do
    File.expand_path("../fixtures/images/person-in-field.jpg", __dir__)
  end

  it "makes the rate limit information accessible" do
    result = VCR.use_cassette("from-file-person-in-field") do
      RemoveBg.from_file(image_path, api_key: api_key)
    end

    rate_limit = result.rate_limit

    expect(rate_limit.total).to be >= 500
    expect(rate_limit.remaining).to be > 0
    expect(rate_limit.reset_at).to be_utc
    expect(rate_limit.reset_at).to be > Time.utc(2020, 5, 20, 16, 0)
    expect(rate_limit.retry_after_seconds).to be_nil
  end
end

require "remove_bg/rate_limit_info"

RSpec.describe RemoveBg::RateLimitInfo do
  describe "#to_s" do
    it "displays the rate limit info in a human readable form" do
      moment = Time.utc(2020, 05, 20, 12)
      headers = {
        "X-RateLimit-Limit" => "500",
        "X-RateLimit-Remaining" => "0",
        "X-RateLimit-Reset" => moment.to_i,
        "Retry-After" => "32",
      }

      description = described_class.new(headers).to_s

      expect(description).to eq(
        "<RateLimit reset_at='2020-05-20T12:00:00Z' retry_after_seconds=32 total=500 remaining=0>"
      )
    end
  end
end

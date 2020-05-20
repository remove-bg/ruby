module RemoveBg
  class RateLimitInfo
    attr_reader :total, :remaining, :retry_after_seconds

    def initialize(headers)
      @total = headers["X-RateLimit-Limit"]&.to_i
      @remaining = headers["X-RateLimit-Remaining"]&.to_i
      @reset_timestamp = headers["X-RateLimit-Reset"]&.to_i
    end

    def reset_at
      return if reset_timestamp.nil?
      Time.at(reset_timestamp).utc
    end

    private

    attr_reader :reset_timestamp
  end
end

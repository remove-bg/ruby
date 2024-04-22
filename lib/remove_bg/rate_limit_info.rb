# frozen_string_literal: true

require "time"

module RemoveBg
  class RateLimitInfo
    attr_reader :total, :remaining, :retry_after_seconds

    def initialize(headers)
      @total = headers["X-RateLimit-Limit"]&.to_i
      @remaining = headers["X-RateLimit-Remaining"]&.to_i
      @reset_timestamp = headers["X-RateLimit-Reset"]&.to_i

      # Only present if rate limit exceeded
      @retry_after_seconds = headers["Retry-After"]&.to_i
    end

    def reset_at
      return if reset_timestamp.nil?

      Time.at(reset_timestamp).utc
    end

    def to_s
      "<RateLimit " \
        "reset_at='#{reset_at.iso8601}' " \
        "retry_after_seconds=#{retry_after_seconds} " \
        "total=#{total} " \
        "remaining=#{remaining}" \
        ">"
    end

    private

    attr_reader :reset_timestamp
  end
end

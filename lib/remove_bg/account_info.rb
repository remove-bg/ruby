module RemoveBg
  class AccountInfo
    attr_reader :api, :credits

    def initialize(attributes)
      @api = ApiInfo.new(**attributes.fetch(:api))
      @credits = CreditsInfo.new(**attributes.fetch(:credits))
    end

    class ApiInfo
      attr_reader :free_calls, :sizes

      def initialize(free_calls:, sizes:)
        @free_calls = free_calls
        @sizes = sizes
      end
    end

    class CreditsInfo
      attr_reader :total, :subscription, :payg, :enterprise

      def initialize(total:, subscription:, payg:, enterprise:)
        @total = total
        @subscription = subscription
        @payg = payg
        @enterprise = enterprise
      end
    end
  end
end

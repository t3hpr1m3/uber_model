module UberModel
  module Adapters
    class AbstractAdapter
      def initialize(spec)
        @spec = spec
      end
      def verify!
      end
    end
  end
end

module UberModel
  module Adapters
    class AdapterManager
      class_attribute :registered
      self.registered = {}

      class << self
        def registered?(name)
          registered.key?(name.to_sym)
        end

        def register(name, klass)
          registered[name.to_sym] = klass
        end
      end

      attr_reader :adapter_pools

      def initialize(pools = {})
        @adapter_pools = pools
        @registered = {}
      end

      def create_adapter(name, spec)
        @adapter_pools[name.to_sym] = AdapterPool.new(spec)
      end

      def retrieve_adapter(klass)
      end
    end
  end
end

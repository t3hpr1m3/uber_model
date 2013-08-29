module UberModel
  module Adapters
    class AdapterSpecification
      attr_reader :name, :adapter, :config

      def initialize(name, config = {})
        unless config.key?(:adapter)
          raise InvalidSpecification, "Adapter not specified: #{config.inspect}"
        end

        @name     = name.to_sym
        @adapter  = config.delete(:adapter).to_sym
        @config   = HashWithIndifferentAccess.new(config)
      end
    end
  end
end

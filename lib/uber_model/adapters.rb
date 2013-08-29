module UberModel
  class AdapterNotSpecified < UberModelError; end
  class InvalidAdapter < UberModelError; end
  class InvalidSpecification < UberModelError; end

  module Adapters
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :AbstractAdapter
    autoload :AdapterManager
    autoload :AdapterPool
    autoload :AdapterSpecification

    included do
      class_attribute :adapter_manager
      self.adapter_manager = UberModel::Adapters::AdapterManager.new
    end

    def adapter
      self.class.retrieve_adapter
    end

    module ClassMethods

      def register_adapter(name, klass)
        unless klass.ancestors.include?(UberModel::Adapters::AbstractAdapter)
          raise InvalidAdapter, "Invalid adapter: #{klass}"
        end
        AdapterManager.register(name, klass)
      end

      def set_adapter(spec = nil)
        case spec
        when nil
          raise AdapterNotSpecified unless defined?(Rails) && Rails.respond_to?(:env)
          set_adapter(Rails.env)
        when Symbol, String
          if s = UberModel::Base.specs[spec.to_sym]
            set_adapter(s)
          else
            raise InvalidSpecification, "#{spec} is not configured"
          end
        when AdapterSpecification
          self.adapter_manager.create_adapter(name, spec)
        end
      end
    end
  end
end

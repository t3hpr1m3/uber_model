module UberModel
  module AttributeMethods
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload

    autoload :Read
    autoload :Write

    included do
      include ActiveModel::AttributeMethods
      include ActiveModel::Dirty
      include Read
      include Write
      class_attribute :model_attributes
      self.model_attributes = []
      attribute_method_suffix('', '=', '_before_type_cast')
    end

    module ClassMethods
      def attribute(name, data_type, *args)
        name = name.to_s
        opts = args.extract_options!
        primary = opts.delete(:primary_key)
        self.primary_key = name if primary.eql?(true)
        default = args.first unless args.blank?
        new_attr = Attribute.new(name, data_type, opts)
        self.model_attributes << new_attr
        define_attribute_method name
      end

      def model_attributes_hash
        @attributes_hash ||= HashWithIndifferentAccess[model_attributes.map { |attribute| [attribute.name, attribute] }]
      end

      def attribute_defaults
        @attribute_defaults ||= Hash[model_attributes.map { |a| [a.name, a.default] }]
      end

      def initialize_attributes(attrs)
        attrs
      end
    end

    def attribute_names
      @attributes.keys
    end

    def attributes
      attribute_names.each_with_object({}) { |name, attrs|
        attrs[name] = read_attribute(name)
      }
    end
  end
end

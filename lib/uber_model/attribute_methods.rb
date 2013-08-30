module UberModel
  module AttributeMethods
    extend ActiveSupport::Concern
    extend ActiveSupport::Autoload
    include ActiveModel::AttributeMethods

    autoload :BeforeTypeCast
    autoload :Read
    autoload :Write

    included do
      include ActiveModel::Dirty
      include BeforeTypeCast
      include Read
      include Write

      # stores the hash of all attributes defined for this model
      class_attribute :model_attributes
      self.model_attributes = []
    end

    module ClassMethods
      #
      # Adds a new {UberModel::Attribute} to the UberModel.
      #
      # @param name [Symbol] Name of the attribute
      # @param data_type [Symbol] One of the suppored
      #   {UberModel::Attribute::VALID_TYPES data types}
      #   supplied)
      # A default value for this attribute can be passed as the third argument.
      #
      # An options hash can also be passed, which allows the following options:
      # - primary_key - (Boolean) Whether or not this attribute should be
      #   treated as the primary key for the model
      #
      # ==== Example:
      #   class Foo < UberModel::Base
      #     attribute :name, :string, 'Unknown', primary_key: true
      #   end
      def attribute(name, data_type, *args)
        name = name.to_s
        opts = args.extract_options!
        primary = opts.delete(:primary_key)
        self.primary_key = name if primary.eql?(true)
        default = args.first unless args.blank?
        new_attr = Attribute.new(name, data_type, opts)
        self.model_attributes = self.model_attributes + [new_attr]
        define_attribute_method name
      end

      # Hash mapping attribute names to their associated
      # {UberModel::Attribute Attribute}.
      def attributes_hash
        @attributes_hash ||= HashWithIndifferentAccess[model_attributes.map { |attribute| [attribute.name, attribute] }]
      end

      # Default values for all attributes associated with this model
      # @return [Hash] Hash containing all attributes and their associated default value
      def attribute_defaults
        @attribute_defaults ||= Hash[model_attributes.map { |a| [a.name, a.default] }]
      end

      # Hook for serialization routines
      def initialize_attributes(attrs, options = {})
        attrs
      end
    end

    # @return [Array] List of valid attributes for this model
    def attribute_names
      @attributes.keys
    end

    # @return [Hash] Hash containing all attributes, with their type_cast values
    def attributes
      attribute_names.each_with_object({}) { |name, attrs|
        attrs[name] = read_attribute(name)
      }
    end

    # Returns the {UberModel::Attribute Attribute} for the given attribute name
    # @param attr_name [String] Attribute name
    # @return [Attribute] {UberModel::Attribute} associated with attr_name
    def attr_for_attribute(attr_name)
      self.class.attributes_hash[attr_name.to_s]
    end
  end
end

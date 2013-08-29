module UberModel
  module AttributeMethods
    module BeforeTypeCast
      extend ActiveSupport::Concern

      included do
        attribute_method_suffix "_before_type_cast"
      end

      def read_attribute_before_type_cast(attr_name)
        @attributes[attr_name.to_s]
      end

      private

      def attribute_before_type_cast(attr_name)
        read_attribute_before_type_cast(attr_name)
      end
    end
  end
end

module UberModel
  module AttributeMethods
    module Read
      extend ActiveSupport::Concern

      included do
        attribute_method_suffix ''
      end

      def read_attribute(name)
        attr_name = name.to_s
        attribute = self.class.attributes_hash.fetch(attr_name) {
          return @attributes.fetch(attr_name) {
            if attr_name == 'id' && self.class.primary_key != attr_name
              read_attribute(self.class.primary_key)
            end
          }
        }

        value = @attributes.fetch(attr_name)

        attribute.type_cast(value)
      end

      private

      def attribute(name)
        read_attribute(name)
      end
    end
  end
end

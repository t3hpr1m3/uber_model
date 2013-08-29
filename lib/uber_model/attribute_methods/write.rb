module UberModel
  module AttributeMethods
    module Write
      extend ActiveSupport::Concern

      included do
        attribute_method_suffix '='
      end

      def assign_attributes(new_attributes, options = {})
        return if new_attributes.blank?

        attributes = new_attributes.stringify_keys

        attributes.each do |k, v|
          if respond_to?("#{k}=")
            send("#{k}=", v)
          else
            raise UnknownAttributeError, "Unknown attribute: #{k}"
          end
        end
      end

      def write_attribute(attr_name, value)
        attr_name = attr_name.to_s
        attr_name = self.class.primary_key if attr_name == 'id' && self.class.primary_key
        attr = attr_for_attribute(attr_name)

        if attr || @attributes.has_key?(attr_name)
          @attributes[attr_name] = type_cast_attribute_for_write(attr, value)
        else
          raise UnknownAttributeError, "Unknown attribute: #{attr_name.inspect}"
        end
      end

      private

      def attribute=(attr_name, value)
        unless read_attribute(attr_name).eql?(value)
          attribute_will_change!(attr_name)
          write_attribute(attr_name, value)
        end
      end

      def type_cast_attribute_for_write(attr, value)
        return value unless attr

        attr.type_cast_for_write value
      end
    end
  end
end

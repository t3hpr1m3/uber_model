module UberModel
  module AttributeMethods
    module Write
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

      def write_attribute(name, value)
        name = name.to_s
        if a = self.class.model_attributes_hash[name]
          @attributes[name] = value
        else
          raise UnknownAttributeError, "Unknown attribute: #{name.inspect}"
        end
      end

      private

      def attribute=(name, value)
        unless read_attribute(name).eql?(value)
          attribute_will_change!(name)
          write_attribute(name, value)
        end
      end
    end
  end
end

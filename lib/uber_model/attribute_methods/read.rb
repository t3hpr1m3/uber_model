module UberModel
  module AttributeMethods
    module Read
      def read_attribute(name)
        name = name.to_s
        @attributes.fetch(name) {
          if name == 'id' && self.class.primary_key != name
            read_attribute(self.class.primary_key)
          end
        }
      end

      private

      def attribute(name)
        read_attribute(name)
      end

      def attribute_before_type_cast(name)
        @attributes[name]
      end
    end
  end
end

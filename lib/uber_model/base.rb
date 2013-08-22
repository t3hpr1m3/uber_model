require 'uber_model/errors'

module UberModel
  class Base
    extend Logging
    include AttributeMethods
    include Identity
    include Persistence
    include Validation

    def initialize(attributes = nil)
      defaults = self.class.attribute_defaults.dup
      @attributes = self.class.initialize_attributes(defaults)

      @persisted = false
      @destroyed = false
      @readonly = true

      assign_attributes(attributes) if attributes
    end
  end
end

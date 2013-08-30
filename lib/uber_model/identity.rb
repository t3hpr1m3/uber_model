module UberModel

  # Provides the identity (id) functionality for models, as well as satisfying
  # the ActiveModel::Conversion requirements.
  module Identity
    extend ActiveSupport::Concern
    include ActiveModel::Conversion

    included do
      class_attribute :primary_key
      self.primary_key = 'id'
      undef_method(:id) if method_defined?(:id)
    end

    # Returns the primary key as an enumerable.
    def to_key
      key = nil
      key = send(self.class.primary_key) if persisted?
      [key] if key
    end

    # Returns a string representing the object's key suitable for use in URLs,
    # or nil if {UberModel::Persistence#persisted? persisted?} is false.
    def to_param
      send(self.class.primary_key).to_s if persisted?
    end
  end
end

module UberModel
  module Validation
    extend ActiveSupport::Concern
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks

    included do
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :create, :update, :destroy, :reload
    end

    def save(options = {})
      perform_validations(options) ? super : false
    end

    def valid?(context = nil)
      context ||= (persisted? ? :update : :create)
      output = super(context)
      errors.empty? && output
    end

    protected

    def perform_validations(options = {})
      perform_validations = options[:validate] != false
      perform_validations ? valid?(options[:context]) : true
    end
  end
end

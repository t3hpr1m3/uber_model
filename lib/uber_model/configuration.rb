module UberModel

  #
  # UberModel configuration.
  #
  module Configuration

    #
    # Used to configure UberModel
    #
    # To use, add an initializer to your app:
    #
    #   UberModel.configure do |config|
    #     config.log_level = :debug
    #   end
    def configure
      yield self
    end

    #
    # Adds a specification to the list of specs
    #
    # @param name [String] Name for this specification (ex. development)
    # @param config [Hash] Hash containing at least an adapter name
    #
    def add_spec(name, config)
      unless spec = specs[name.to_sym]
        spec = UberModel::Adapters::AdapterSpecification.new(name, config)
        specs[name.to_sym] = spec
      end
      spec
    end

    #
    # Adapter specifications
    #
    mattr_accessor :specs
    @@specs = {}
  end
end

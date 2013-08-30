require 'active_support'
require 'active_support/core_ext'
require 'active_model'

require 'uber_model/version'
require 'uber_model/errors'

module UberModel
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Adapters
  autoload :Attribute
  autoload :AttributeMethods
  autoload :Configuration
  autoload :Errors
  autoload :Identity
  autoload :Logging
  autoload :Persistence
  autoload :Predicate
  autoload :Validation
end

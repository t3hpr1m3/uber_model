require 'active_support'
require 'active_support/core_ext'
require 'active_model'

require 'uber_model/version'
require 'uber_model/errors'

module UberModel
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Attribute
  autoload :AttributeMethods
  autoload :Errors
  autoload :Identity
  autoload :Logging
  autoload :Persistence
  autoload :Validation
end

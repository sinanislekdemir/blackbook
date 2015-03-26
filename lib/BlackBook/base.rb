################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'BlackBook/logger'
require 'BlackBook/registry'

module BlackBook
  # BlackBook Base Class
  class Base
    attr_accessor :logger, :registry
    attr_writer :logger, :registry

    def initialize(*_args)
      logging_params = { filename: 'debug.log', stdout: true }
      Logger.instance.define logging_params
      @registry = Registry.instance
    end
  end
end

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'bb_logger'

# BlackBook Base Class
class BBBase
  attr_accessor :logger
  attr_writer :logger

  def initialize(*_args)
    logging_params = { filename: 'debug.log', stdout: true }
    @logger = BBLogger.new logging_params
  end
end

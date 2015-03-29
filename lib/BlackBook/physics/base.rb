################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'BlackBook/base'
require 'BlackBook/stime'
require 'BlackBook/constants'

module BlackBook
    # Physics module for BlackBook Space
  class Physics < Base
    attr_accessor :variables, :constraints, :global_time, :name
    attr_writer :name

    # initialize engine
    def initialize(space = nil)
      super
      @global_time = STime.new
      @variables = []
      @constraints = {}
      # leave like this for infinite environment
      # infinite environment may cause slow calculations
      @constraints[:min] = CVector.new(0, 0, 0, 1)
      @constraints[:max] = CVector.new(0, 0, 0, 1)
      @name = ''
    end

    def load_variables(filename)
    end

    def apply_variables
    end
  end
end

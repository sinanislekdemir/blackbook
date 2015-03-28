################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'json'

# Local Libs
require 'BlackBook/base'
require 'BlackBook/stime'
require 'BlackBook/constants'
require 'BlackBook/physics/newton/newton'

module BlackBook
  # Physics module for BlackBook Space
  module Physics
    # Generalized class for Physics
    class BlackBookPhysics < Base
      attr_accessor :items, :variables, :constraints, :global_time, :name
      attr_writer :name

      def initialize
        super
        @global_time = STime.new
        @items = {}
        @variables = []
        @constraints = {}
        # leave like this for infinite environment
        # infinite environment may cause slow calculations
        @constraints[:min] = CVector.new(0, 0, 0, 1)
        @constraints[:max] = CVector.new(0, 0, 0, 1)
        @name = ''
      end

      def load_variables(filename)
        f = File.open(filename, 'r')
        @variables = JSON.parse(f.read)
        f.close
      end

      def render
        @items.each do |_name, object|
          object.render
        end
      end

      def apply_variables
      end
    end
    extend self
    VERSION = '0.0.1'
  end
end

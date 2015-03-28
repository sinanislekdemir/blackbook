#!/usr/bin/env ruby

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
#
# Simple Application Sample Source
################################################################

# Add library path to rubtime
$LOAD_PATH << '../lib/'

require 'json'

# Local Libs
require 'blackbook'
require 'ui'
require 'plugins'

# Main application
module BlackBook
  # Application object
  class Main < BlackBook::Engine
    attr_accessor :space
    attr_writer :space

    def initialize(w, h, title, w_multiplier = 1, h_multiplier = 1)
      # First initialize BlackBook Engine
      super
      # Create 3D space
      @space = Space.new(
        @window_width * w_multiplier,
        @window_height * h_multiplier
        )
    end

    def render
      super
      # Initialize space if gl is not active
      @space.init_gl unless @space.gl_active
      @space.render
    end
  end
end

BlackBook::Main.new(800, 600, 'BlackBook Sample').engine_start

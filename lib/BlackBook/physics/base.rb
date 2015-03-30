##############################################################################
#    BlackBook 3D Engine
#    Copyright (C) 2015  Sinan ISLEKDEMIR
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
##############################################################################

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

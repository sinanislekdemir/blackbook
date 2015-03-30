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

require 'singleton'
require 'json'

# Blackbook Registry for global variables
module BlackBook
  # Singleton Registry class
  class Registry
    include Singleton

    attr_writer :params
    attr_accessor :params

    # Create empty hash
    def initialize
      @params = {}
    end

    # read object from hash, return nil if not found
    def read(key)
      @params.key?(key) ? @params[key] : nil
    end

    # write to instance hash
    def write(key, value)
      @params[key] = value
    end

    # actually just a shortcut :)
    def exists(key)
      @params.key? key
    end

    # save current parameters to file as json
    def save_to_file(filename)
      File.write filename, @params.to_json
    end

    # load from json file
    def load_from_file(filename)
      buffer = File.read(filename)
      @params = JSON.parse(buffer)
    end
  end
end

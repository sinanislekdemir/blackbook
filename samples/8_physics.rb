#!/usr/bin/env ruby
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
      # Enable GRID for the scene
      BlackBook::Registry.instance.write('grid', true)
      BlackBook::Registry.instance.write('data_path', '../data')
      # Create 3D space
      @space = Space.new(
        @window_width * w_multiplier,
        @window_height * h_multiplier
        )
      # Add camera to space
      # Eye position
      eye = CVector.new 10.0, 10.0, 10.0
      # Camera UP is Z
      up  = CVector.new 0.0, 0.0, 1.0
      # Camera target is origin
      target = CVector.new 0.0, 0.0, 0.0
      @space.add_camera(
        eye_position: eye,
        up: up,
        target_position: target
        )
    end

    def render
      super
      # Initialize space if gl is not active
      @space.init_gl unless @space.gl_active
      @space.render
      # Enable mouse events
      @space.mouse_move(
        @main_window.cursor_pos[0],
        @main_window.cursor_pos[1],
        @right,
        @left,
        @middle)
    end
  end
end

abort('Work in progress')

# On Macbook Pro, window multipliers has to be set to 2
# On other systems set it to 1
# Can someone please explain this and show me how to fix that?
window_multiplier_x = 2
window_multiplier_y = 2
BlackBook::Main.new(
  800,
  600,
  'BlackBook Sample',
  window_multiplier_x,
  window_multiplier_y
  ).engine_start

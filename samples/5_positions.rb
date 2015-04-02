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
      BlackBook::Registry.instance.write('grid_count', 10)
      BlackBook::Registry.instance.write('grid_size', 3)

      # Create 3D space
      @space = Space.new(
        @window_width * w_multiplier,
        @window_height * h_multiplier
        )
      # Add camera to space
      # Eye position
      eye = CVector.new 20.0, 20.0, 20.0
      # Camera UP is Z
      up  = CVector.new 0.0, 0.0, 1.0
      # Camera target is origin
      target = CVector.new 0.0, 0.0, 0.0
      @space.add_camera(
        eye_position: eye,
        up: up,
        target_position: target
        )
      # Add a light to scene
      light = @space.create_light
      light.position.set(10.0, 5.0, 10.0)
      # Add our objects
      # You have to give each object a UNIQUE NAME!!!
      obj_1 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_1'
        )
      obj_2 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_2'
        )
      obj_3 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_3'
        )
      obj_4 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_4'
        )
      obj_5 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_5'
        )
      obj_1.material.color.set(1.0, 0.0, 0.0, 0.9)
      obj_2.material.color.set(1.0, 1.0, 0.0, 0.3)
      obj_3.material.color.set(1.0, 0.0, 1.0, 0.5)
      obj_4.material.color.set(0.0, 1.0, 0.0, 1.0)
      obj_5.material.color.set(0.0, 1.0, 1.0, 0.7)
      obj_2.position.x = 8.0
      obj_3.position.y = 5.0
      obj_3.position.z = 6.7
      obj_3.roll = 45
      obj_4.position.z = -4.0
      obj_4.pitch = 45
      obj_4.yaw = 39
      obj_5.position.y = 9.0
      obj_5.position.z = 3.0
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

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

    def initialize(w, h, title)
      # First initialize BlackBook Engine
      super
      # Enable GRID for the scene
      BlackBook::Registry.instance.write('grid', true)
      BlackBook::Registry.instance.write('grid_count', 10)
      BlackBook::Registry.instance.write('grid_size', 3)

      # Create 3D space
      @space = Space.new(
        @viewport_x,
        @viewport_y
      )
      # Add camera to space
      # Eye position
      eye_1 = CVector.new 20.0, 20.0, 20.0
      # Camera UP is Z
      up_1  = CVector.new 0.0, 0.0, 1.0
      # Camera target is origin
      target_1 = CVector.new 0.0, 0.0, 0.0
      w_half_of_screen = @viewport_x / 2
      @space.add_camera(
        eye_position: eye_1,
        up: up_1,
        target_position: target_1,
        frame_x: 0,
        frame_y: 0,
        frame_width: w_half_of_screen,
        frame_height: @viewport_y
      )
      # Add camera to space
      # Eye position
      eye_2 = CVector.new 10.0, -10.0, 10.0
      # Camera UP is Z
      up_2  = CVector.new 0.0, 0.0, 1.0
      # Camera target is origin
      target_2 = CVector.new 0.0, 0.0, 0.0
      @space.add_camera(
        eye_position: eye_2,
        up: up_2,
        target_position: target_2,
        frame_x: w_half_of_screen,
        frame_y: 0,
        frame_width: w_half_of_screen,
        frame_height: @viewport_y
      )

      # Add a light to scene
      light = @space.create_light
      light.position.set(10.0, 5.0, 10.0)

      light_2 = @space.create_light
      light_2.position.set(-10.0, -5.0, 10.0)
      # Add our objects
      # You have to give each object a UNIQUE NAME!!!
      @space.add_object(
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
      obj_2.matrix.pos.x = 8.0
      obj_3.matrix.pos.y = 5.0
      obj_3.matrix.pos.z = 6.7
      obj_4.matrix.pos.z = -4.0
      obj_5.matrix.pos.y = 9.0
      obj_5.matrix.pos.z = 3.0
    end

    def mouse_move(x, y, right, left, middle)
      super
      @space.mouse_move(
        x * (@viewport_x / @window_width),
        y * (@viewport_y / @window_height),
        right,
        left,
        middle)
    end

    def render
      super
      # Initialize space if gl is not active
      @space.init_gl unless @space.gl_active
      @space.render
    end
  end
end

BlackBook::Main.new(
  800,
  600,
  'BlackBook Sample'
).engine_loop

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
      @animate = false
      # Enable GRID for the scene
      BlackBook::Registry.instance.write('grid', true)
      BlackBook::Registry.instance.write('grid_count', 10)
      BlackBook::Registry.instance.write('grid_size', 3)
      BlackBook::Registry.instance.write('collision_algorithm', 'AABB')

      # Create 3D space
      @space = Space.new(
        @viewport_x,
        @viewport_y
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
      obj_3 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_3'
        )
      obj_4 = @space.add_object(
        filename: '../data/cube.raw',
        name: 'cube_object_4'
        )
      obj_1.material.color.set(1.0, 0.0, 0.0, 0.9)
      obj_3.material.color.set(1.0, 0.0, 1.0, 0.5)
      obj_4.material.color.set(0.0, 1.0, 0.0, 1.0)
      obj_1.mass = 0.0
      obj_3.mass = 1.0
      obj_4.mass = 1.0
      obj_4.matrix.pos.z = 7.0
      @physics = BlackBook::Newton.new(@space)
      gravity = -0.80665
      @physics.add_variable(
        CAcceleration.new(
          CVector.new(0, 0, gravity), 'gravity'
          )
        )
      @physics.on_collide = -> (colls) do
        puts "Total collisions: " + colls.count.to_s
      end
      # physics.run(1)
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
      @physics.step(@physics.global_time.step) if @animate
      @space.render
      @physics.global_time.reset_time if @animate
    end

    def keypress(chr)
      @animate = !@animate if chr == ' '
      @physics.global_time.reset_lasttime
    end
  end
end

BlackBook::Main.new(
  800,
  600,
  'BlackBook Sample'
  ).engine_loop

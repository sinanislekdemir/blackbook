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
      # Enable GRID for the scene
      BlackBook::Registry.instance.write('grid', true)
      # Required for loading fonts from proper folder.
      BlackBook::Registry.instance.write('data_path', '../data')
      # Create 3D space
      @space = Space.new(
        @window_width * w_multiplier,
        @window_height * h_multiplier,
        w_multiplier
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
      obj_2.position.x = 8.0
      obj_3.position.y = 5.0
      obj_3.position.z = 6.7
      obj_3.roll = 45
      obj_4.position.z = -4.0
      obj_4.pitch = 45
      obj_4.yaw = 39
      obj_5.position.y = 9.0
      obj_5.position.z = 3.0

      ui = @space.create_ui
      window = ui.add_window(
        x: 10, y:10, z: 1, w: 500, h: 400, title: 'Window Title', name: 'w1'
        )
      window.create_label(x: 10, y: 60, title: 'UI Sample')
      button = window.create_button(
        x: 10, y: 150, w: 200, title: 'Quit', name: 's_button'
        )
      button.click = -> do
        exit
      end
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

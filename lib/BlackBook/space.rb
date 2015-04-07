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

require 'opengl'
require 'pp'
require 'json'
require 'securerandom' # Ruby 1.9 and above

# Local Libs
require 'BlackBook/constants'
require 'BlackBook/functions'
require 'BlackBook/camera'
require 'BlackBook/base'
require 'BlackBook/light'
require 'ui/ui'
require 'BlackBook/physics/physics'

module BlackBook
  #
  # BB Space Class. Holds main scene elements.
  # There can be more than one space in an engine and more than one cameras
  # In every Space
  #
  # @author [sinan]
  #
  # @attr width [Integer] Space Viewport Width
  # @attr heigh [Integer] Space Viewport Height
  # @attr gl_active [Boolean] OpelGL Activated
  # @attr multiplier [Float] Viewport - Window Multiplier
  # @attr items [Hash] Hash of items
  #
  class Space < Base
    attr_accessor :width, :height, :physics, :gl_active, :muliplier, :items
    attr_writer :width, :height, :physics, :gl_active, :muliplier, :items

    # Initialize scene,
    # set lights, init opengl
    # set perspective
    def initialize(w, h, m = 1)
      super
      @muliplier = m
      @physics = []
      @gl_active = false
      @width, @height = w, h
      @items = {
        cameras: [],
        lights:  [],
        objects: {},
        uis:     [],
        plugins: []
      }
    end

    #
    # Create camera with given parameters
    # @param options [Hash] BBCamera Options (see BBCamera#initialize)
    #
    # @return [Camera] Camera object
    def add_camera(options)
      camera = Camera.new(options)
      @items[:cameras].push camera
      camera
    end

    #
    # Create a new scene camera and add it to the scene hash
    #
    # @return [Camera] Camera object
    def create_camera
      camera = Camera.new(
        eye_position: CVector.new(10.0, 10.0, 10.0),
        target_position: CVector.new(0, 0, 0),
        up: CVector.new(0.0, 0.0, 1.0)
        )
      @items[:cameras].push camera
    end

    #
    # Add new object
    # @param options [Hash] Options of new object
    #                :filename => Raw file, filename
    #                :roll     => Roll angle
    #                :pitch    => Pitch angle
    #                :yaw      => Yaw angle
    #                :position => CVector
    #                :time     => Time float
    #                :name     => Name of the object
    #                :scale    => Scale CVector
    #
    # @return [BB3DObject] 3D Object
    def add_object(options)
      obj = B3DObject.new
      obj.load_raw(options[:filename]) if options.key?(:filename)
      obj.matrix.position = options[:position] if options.key?(:position)
      obj.time = options[:time] if options.key?(:time)
      name = options.key?(:name) ? options[:name] : SecureRandom.uuid
      obj.name = name
      obj.scale = options[:scale] if options.key?(:scale)
      @items[:objects][name] = obj
      obj
    end

    #
    # Create a dummy object
    #
    # @return [BB3DObject] 3D Object
    def create_object
      obj = B3DObject.new
      name = SecureRandom.uuid
      @items[:objects][name] = obj
      obj
    end

    #
    # Add Light
    # @param options [Hash] Light Properties
    #
    # @return [Boolean] Success
    def add_light(options)
      light = Light.new(options)
      @items[:lights].push light
      light
    end

    #
    # Create a default light
    #
    # @return [BBLight]
    def create_light
      light = Light.new({})
      @items[:lights].push light
      light
    end

    #
    # Create a UI Interface Object
    #
    # @return [type] [description]
    def create_ui
      ui = UI::Ui.new(@width, @height)
      @items[:uis].push ui
      ui
    end

    #
    # Create Physics Dynamics Engine
    # @return [BlackBookPhysics] BlackBook Physics Object
    def create_dynamics
      @physics << BlackBook::Newton.new(self)
    end

    #
    # Initialize OpenGL
    #
    # @return [Boolean] Initialize main OpenGL Variables
    def init_gl
      GL.Viewport(0, 0, @width, @height)
      GL.ClearDepth(1.0)
      GL.DepthFunc(GL::LESS)
      GL.Enable(GL::DEPTH_TEST)
      GL.ShadeModel(GL::SMOOTH)
      GL.MatrixMode(GL::PROJECTION)
      GL.LoadIdentity
      BlackBook.perspective(30.0, @width.to_f / @height.to_f, 1.0, 1000.0)
      GL.MatrixMode(GL::MODELVIEW)
      GL.ClearColor(0.05, 0.05, 0.1, 1.0)
      @gl_active = true
    end

    #
    # Main Mouse Move Handler for Space
    # 1. Mouse move for each plugin
    # 2. Mouse move for each ui
    # 3. Mouse move for each camera
    #
    # @param x [Integer] Mouse X Axis Value
    # @param y [Integer] Mouse Y Axis Value
    # @param right_b [Integer] Right Mouse Button
    # @param left_b [Integer] Left Mouse Button
    # @param middle_b [Integer] Middle Mouse Button
    #
    # @return [Boolean] Success
    def mouse_move(x, y, right_b, left_b, middle_b)
      x *= @muliplier
      y *= @muliplier
      @items[:plugins].each do |plugin|
        if plugin.respond_to('mouse_move')
          plugin.mouse_move(x, y, right_b, left_b, middle_b)
        end
      end
      @items[:uis].each do |ui|
        return true if ui.mouse_move(x, y, right_b, left_b, middle_b)
      end
      @items[:cameras].each do |camera|
        camera.mouse_move(x, y, right_b, left_b, middle_b)
      end
    end

    #
    # General Render Method
    # 1. Render Lights
    # 2. Call Light Methods of Plugins
    # 3. Call Camera Methods of Plugins
    #    Make it before real cameras for shaders)
    # 4. Render Cameras
    #   4a. Render Objects
    #   4b. Call Render Methods of Plugins
    # 5. Render UI's
    # 6. Call ui Methods of Plugins
    #
    # @return [type] [description]
    def render
      # Render Plugin Cameras
      @items[:plugins].each do |plugin|
        plugin.camera if plugin.respond_to?('camera')
      end
      # Render Objects for each camera
      @items[:cameras].each do |cam|
        cam.begin_render
        grid = BlackBook::Registry.instance.read('grid')
        BlackBook.draw_grid if grid
        # Render Lights
        @items[:lights].each do |light|
          light.render
        end
        # Render Plugins Lights
        @items[:plugins].each do |plugin|
          plugin.light if plugin.respond_to?('light')
        end
        @items[:objects].each do |name, obj|
          obj.render
          # Render Plugins
          @items[:plugins].each do |plugin|
            plugin.render if plugin.respond_to?('render')
          end
        end
        cam.end_render
      end
      GL.Viewport(0, 0, @width, @height)
      @items[:uis].each do |ui|
        ui.render
      end
      @items[:plugins].each do |plugin|
        plugin.ui if plugin.respond_to?('ui')
      end
    end

    def save(filename)
      space_json = JSON.generate(@physics)
      File.open(filename, 'w') { |file| file.write(space_json) }
    end
  end
end

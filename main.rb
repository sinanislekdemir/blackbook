#!/usr/bin/env ruby

$LOAD_PATH << './lib/'

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'pp'
require 'json'

# Local Libs
require 'blackbook'
require 'ui'
require 'plugins'

# main application
module BlackBook
  # Main Application handler
  class Main < BlackBook::Engine
    attr_accessor :space, :space2
    attr_writer :space, :space2

    def initialize(w, h, title, w_multiplier = 1, h_multiplier = 1)
      super
      BlackBook::Registry.instance.write('shader', 'vbo')
      @space = Space.new(@window_width * w_m, @window_height * h_m, w_m)
      cam = @space.add_camera(
        eye_position: CVector.new(10.0, 10.0, 10.0),
        up: CVector.new(0.0, 0.0, 1.0),
        target_position: CVector.new(0, 0, 0)
        )
      light = @space.create_light
      light.position.set(5.0, 5.0, 5.0)
      @space.add_object(
        filename: 'data/wings.raw',
        name: 'idontknow'
        )
      o = @space.add_object(
        filename: 'data/ground.raw',
        name: 'idontknowground'
        )
      o.position.z = -0.5
      ui = @space.create_ui
      w = ui.add_window(
        x: 10, y: 10, z: 1, w: 1000, h: 400, title: 'Deneme', name: 'test'
        )
      label = w.create_label(x: 10, y: 60, title: 'Object Position')
      # e = w.create_edit(x: 10, y: 100, w: 200, value: 'testing', name: 'ed')
      b = w.create_button(x: 10, y: 150, w: 200, title: 'buton', name: 'bt')
      b.click = -> do
        ui.add_window(
          x: 10, y: 400, z: 1, w: 1000, h: 400, title: 'Subw', name: 'sub'
        )
      end
      on_update = -> (camera, x, y, obj) do
        v = camera.world_to_screen(CVector.new(2, 2, 0))
        obj.text = v[0].to_s + ' ' + v[1].to_s
      end
      cam.on_update = [on_update, label]
      @space.create_dynamics
    end

    def load(file)
      # @space.load file
    end

    def render
      super
      @space.init_gl if @space.gl_active == false
      @space.render
      @space.mouse_move(
        @main_window.cursor_pos[0],
        @main_window.cursor_pos[1],
        @right,
        @left,
        @middle)
    end
  end
end

# buffer = File.read('data/engine_conf.json')
# d = JSON.parse buffer
w = BlackBook::Main.new(800, 600, 'BlackBook Project', 2, 2)
# w.load d['load']

w.engine_start

#!/usr/bin/env ruby

$LOAD_PATH << './lib/'

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'pp'
require 'sqlite3'
require 'terminal-table'

# Local Libs
require 'bb_space'
require 'bb_engine'
require 'bb_logger'
require 'addons/string_color'
require 'json'

# main application
class Main < BBEngine
  attr_accessor :space, :space2
  attr_writer :space, :space2

  def initialize(w, h, title, w_multiplier = 1, h_multiplier = 1)
    super
    @space = BBSpace.new(@window_width * w_m, @window_height * h_m, w_m)
    ep = CVector.new(10, 10, 10, 1)
    target = CVector.new(0, 0, 0, 1)
    up = CVector.new(0, 0, 1, 0)
    cam = @space.add_camera(
      eye_position: CVector.new(10.0, 10.0, 10.0),
      up: CVector.new(0.0, 0.0, 1.0),
      target_position: CVector.new(0, 0, 0)
      )
    light = @space.create_light
    light.position.set(5.0, 5.0, 5.0)
    @space.add_object(
      filename: 'data/untitled.raw',
      name: 'idontknow'
      )
    @space.add_object(
      filename: 'data/ground.raw',
      name: 'idontknowground'
      )
    ui = @space.create_ui
    w = ui.add_window(
      x: 10, y: 10, z: 1, w: 1000, h: 400, title: 'Deneme'
      )
    label = w.create_label({
      x: 10, y: 60, title: 'Object Position'
      })
    on_update = -> (camera, x, y, obj) {
      v = camera.world_to_screen(CVector.new(2, 2, 0))
      # obj.text = v.x.to_s + ' ' + v.y.to_s + ' ' + v.z.to_s
      obj.text = v[0].to_s + ' ' + v[1].to_s
      # cam_loc = objs[0].screen_to_world(objs[1], objs[2])
    }
    cam.on_update = [on_update, label]
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

#buffer = File.read('data/engine_conf.json')
#d = JSON.parse buffer
w = Main.new(1200, 800, "BlackBook Project", 2, 2)
#w.load d['load']

w.engine_start

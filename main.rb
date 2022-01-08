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

    def initialize(w, h, title)
      super
      n = Time.now.to_f
      BlackBook::Registry.instance.write('shader', 'displaylist')
      BlackBook::Registry.instance.write('grid', true)
      BlackBook::Registry.instance.write('grid_count', 10)
      BlackBook::Registry.instance.write('grid_size', 3)

      @space = Space.new(
        @viewport_x,
        @viewport_y
      )
      c = @space.add_camera(
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
      o.matrix.pos.z = -0.5
      ui = @space.create_ui
      w = ui.add_window(
        x: 10, y: 10, z: 1, w: 1000, h: 400, title: 'Deneme', name: 'test'
      )
      label = w.create_label(x: 10, y: 60, title: 'Object Position')
      # e = w.create_edit(x: 10, y: 100, w: 200, value: 'testing', name: 'ed')
      b = w.create_button(x: 10, y: 150, w: 200, title: 'buton', name: 'bt')
      b.click = lambda do
        ui.add_window(
          x: 10, y: 400, z: 1, w: 1000, h: 400, title: 'Subw', name: 'sub'
        )
      end
      on_update = lambda do |camera, x, y, obj|
        v = camera.world_to_screen(CVector.new(2, 2, 0))
        obj.text = v[0].to_s + ' ' + v[1].to_s
      end
      c.on_update = [on_update, label]
      d = Time.now.to_f - n
      puts "Init: #{d} sec\n"
    end

    def load(file)
      # @space.load file
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
      @space.init_gl if @space.gl_active == false
      @space.render
    end
  end
end

# buffer = File.read('data/engine_conf.json')
# d = JSON.parse buffer
w = BlackBook::Main.new(800, 600, 'BlackBook Project')
# w.load d['load']

w.engine_loop

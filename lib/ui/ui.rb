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
require 'BlackBook/base'
require 'ui/text'
require 'ui/window'

module UI
  # Main UI Hud Controller
  class Ui < BlackBook::Base
    attr_writer :w, :h, :items, :scale, :depth
    attr_accessor :w, :h, :items, :scale, :depth

    def initialize(w, h, scale = 10)
      super
      @items = {}
      @w = w
      @h = h
      @scale = scale
      @depth = 0
    end

    #
    # Add a new windows
    # @param options [Hash] Window properties
    #
    # @return [BBWindow] Created Window Object
    def add_window(options)
      w = Window.new(options)
      w.z = @depth * 100
      @items[options[:name]] = w
      @depth += 1
      w
    end

    def render
      GL.PushMatrix
      GL.Disable(GL::LIGHTING)
      GL.MatrixMode(GL::PROJECTION)
      GL.PushMatrix
      GL.LoadIdentity
      GL.Ortho(0.0, @w, @h, 0.0, -1.0, 10.0)
      GL.MatrixMode(GL::MODELVIEW)
      GL.LoadIdentity
      GL.Disable(GL::DEPTH_TEST)
      GL.Disable(GL::CULL_FACE)
      GL.Clear(GL::DEPTH_BUFFER_BIT)
      @items.each do |key, item|
        item.render
      end
      GL.Enable(GL::DEPTH_TEST)
      GL.MatrixMode(GL::PROJECTION)
      GL.PopMatrix
      GL.MatrixMode(GL::MODELVIEW)
      GL.Enable(GL::LIGHTING)
      GL.PopMatrix
    end

    def mouse_move(x, y, right_b, left_b, middle_b)
      @items.clone.each do |name, obj|
        obj.mouse(x, y, right_b, left_b, middle_b) if obj.respond_to?('mouse')
      end
      false
    end
  end
end

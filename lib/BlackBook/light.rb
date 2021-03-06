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

#################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'BlackBook/base'
require 'BlackBook/functions'

module BlackBook
  #
  # Main Light Object
  #
  # @author [sinan islekdemir]
  #
  # @attr index [Integer] Main index counter of OpenGL Lights (1..8)
  # @attr self_index [Integer] Light Index of the current light
  # @attr position [CVector] Position of the light
  # @attr draw_light [Boolean] Draw the light sphere or not?
  # @attr diffuse [CVector] Diffuse color RGBA(255, 255, 255, 1)
  # @attr light_draw_radius [Float] Draw sphere radius if draw_light is true
  #
  class Light < Base
    attr_accessor :index, :self_index, :position, :draw_light, :diffuse,
                  :light_draw_radius

    @@index = 0
    #
    # Create a new light object
    # @param options [Hash] Options (:position, :draw_light, :diffuse...)
    #
    # @return [Boolean] Success
    def initialize(options)
      @self_index = @@index
      @draw_light = true
      @position = CVector.new(0.0, 0.0, 10.0)
      @light_draw_radius = 1.0
      @diffuse = CVector.new(1.0, 1.0, 1.0, 1.0)
      @position = options[:position] if options.key?(:position)
      @draw_light = options[:draw_light] if options.key?(:draw_light)
      @diffuse = options[:diffuse] if options.key?(:diffuse)
      if options.key?(:light_draw_radius)
        @light_draw_radius = options(:light_draw_radius)
      end
      @@index += 1
    end

    #
    # Simple rendering procedure
    #
    # @return [Boolean] Success
    def render
      return false if @self_index > 7
      GL.Enable(GL::COLOR_MATERIAL)
      if @draw_light
        GL.Disable(GL::LIGHTING)
        GL.PushMatrix
        BlackBook.apply_color(CVector.new(255, 255, 0, 1))
        GL.Translatef(@position.x, @position.y, @position.z)
        BlackBook.draw_circle(@light_draw_radius, 10)
        GL.Rotatef(90.0, 1.0, 0, 0)
        BlackBook.draw_circle(@light_draw_radius, 10)
        BlackBook.apply_color(CVector.new(255, 255, 255, 1))
        GL.PopMatrix
        GL.Enable(GL::LIGHTING)
      end
      light = GL::LIGHT0 + @self_index # (16384 + ...)
      GL.Light(light, GL::DIFFUSE, @diffuse.to_array)
      GL.Light(light, GL::POSITION, @position.to_array)
      GL.Enable(light)
      GL.Enable(GL::LIGHTING)
      GL.Enable(GL::DEPTH_TEST)
      true
    end
  end
end

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

require 'ui/ui_element'
require 'ui/text'
require 'BlackBook/functions'

module UI
  #
  # BB Edit Class
  #
  # @attr value [String] String Value of edit
  # @attr on_keypress [Method] On Keypress Event
  # @attr font_size [Integer] Font size in Pixels
  # @attr max_chars [Integer] Max Size of characters
  # @attr focus [Boolean] Item focusted?
  # @author [sinan islekdemir]
  #
  class Edit < UiElement
    attr_accessor :value, :on_keypress, :font_size, :max_chars, :focus,
                  :text
    attr_writer :value, :on_keypress, :font_size, :max_chars, :focus,
                :text

    #
    # Initialize BBEdit Element
    # @param options [Hash] (x,y,z,w,h,value,font_size)
    #
    # @return [Boolean] Focus
    def initialize(options)
      super
      @font_size = options.key?(:font_size) ? options[:font_size] : 30
      @on_keypress = nil
      @max_chars = options.key?(:max_chars) ? options[:max_chars] : 255
      @value = options.key?(:value) ? options[:value] : ''
      @focus = options.key?(:focus) ? options[:focus] : false
      @text = Text.new(x: 0, y: 0, h: @font_size, title: value)
      @text.color.set(200, 200, 200)
      @text.d = 2
      @h = @font_size + 10.0
    end

    def render
      color = BlackBook::CVector.new(0, 0, 0, 0.8)
      options = {
        x: @x, y: @y, z: 1 / (10000 - @z.to_f),
        width: @w, height: @h, color: color,
        border: true, border_color: BlackBook::CVector.new(0, 255, 255, 0.8)
      }
      BlackBook.draw_box_2d(options)
      GL.PushMatrix
      GL.Translatef(@x, @y, 1 / (10000 - @z.to_f + 1000))
      @text.text = @value
      @text.position.x = 10
      @text.position.y = 30
      @text.render
      GL.PopMatrix
    end

    #
    # Mouse event handler
    # @param x [Integer] Cursor X Position
    # @param y [Integer] Cursor Y Position
    # @param right_b [Integer] Right Mouse Button
    # @param left_b [Integer] Left Mouse Button
    # @param middle_b [Integer] Middle Mouse Button
    #
    # @return [Boolean] Success
    def mouse(x, y, right_b, left_b, middle_b)
      x -= @x
      y -= @y
      @hover = false
      return false unless left_b == 1
      if (x > 0 && x < @w && y > 0 && y < @h) && left_b == 1
        focus = true
      elsif (x < 0 || x > @w || y < 0 || y > @h) && left_b == 1
        focus = false
      end
    end

    def key(char)
      value += char
    end
  end
end

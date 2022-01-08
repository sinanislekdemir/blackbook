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
require 'BlackBook/constants'
require 'BlackBook/functions'

module UI
  #
  # BB Button Class
  #
  # @attr label [String] Label on button
  # @attr click [Method] OnClick event handler
  # @attr caption [BBText] Caption object over button surface
  # @attr hover [CVector] OnHover Color
  # @attr font_size [Integer] Font Size in Pixels
  # @attr caption_w [Integer] width of the caption in pixels
  # @author [sinan islekdemir]
  #
  class Button < UiElement
    attr_accessor :label, :click, :caption, :hover, :font_size, :caption_w

    #
    # Initialize BBButton Element
    # @param options [Hash] (x, y, z, w, h, title, font_size)
    #
    # @return [Boolean] Reposition done
    def initialize( opts = {} )
      super
      title = opts[:title] || ''
      @font_size = opts[:font_size] || 30
      @caption = Text.new(x: 0,
                          y: 0, 
                          h: @font_size,
                          title: title)
      @caption_w = @caption.width
      @click = nil
      @hover = false
      reposition
    end

    #
    # Reposition text on button in case of changing title
    #
    # @return [Boolean] Success
    def reposition
      @w = @caption.width + 30 if @w < @caption.width + 30
      @caption.d = 2
      @caption.position.z = 2
      @caption.position.x = (@w - @caption_w) / 2
      @caption.position.y = @y + @font_size
      true
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
    def mouse(x_coord, y_coord, right_b, left_b, middle_b)
      x = x_coord - @x
      y = y_coord - @y
      @hover = false
      return false if x < 0 || x > 800 || y < 0 || y > 600
      @hover = true
      click.call if left_b == 1
    end

    #
    # General Renderer
    #
    # @return [Boolean] Success
    def render
      color_hover   = BlackBook::CVector.new(255, 165, 0, 0.8)
      color_normal  = BlackBook::CVector.new(0, 0, 0, 0.8)
      color = @hover ? color_hover : color_normal
      options = {
        x: @x, y: @y, z: 1 / (10000 - @z.to_f),
        width: @w, height: @h, color: color,
        border: true, border_color: BlackBook::CVector.new(255, 165, 0, 0.8)
      }
      BlackBook.draw_box_2d(options)
      GL.PushMatrix
      GL.Translatef(5, 0, 1 / (10000 - @z.to_f))
      @hover ? @caption.color.set(0, 0, 0) : @caption.color.set(1.0, 1.0, 1.0)
      @caption.y = 5
      @caption.render
      GL.PopMatrix
    end
  end
end

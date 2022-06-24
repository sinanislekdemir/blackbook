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

require 'BlackBook/functions'
require 'ui/ui_element'
require 'ui/text'
require 'ui/button.rb'
require 'ui/edit.rb'

module UI
  #
  # BB Window Class
  #
  # @attr title_bar [BBText] Title Bar Element
  # @attr items [Hash] Items of widgets inside window
  # @attr font_size [Integer] Font size in pixels
  # @author [sinan]
  #
  class Window < UiElement
    attr_accessor :title_bar, :items, :font_size

    #
    # Initialize Window Element
    # @param options [Hash] (x, y, z, w, h, title, font_size)
    #
    # @return [Hash] Empty Items Hash
    def initialize( opts = {} )
      super
      @font_size = opts[:font_size] || 13
      title = opts[:title] || ''
      @title_bar = Text.new(x: 0, y: 0, w: 0, h: @font_size, title: title)
      @title_bar.d = 2
      @title_bar.position.x = 5
      @title_bar.position.y = @font_size - 5
      @title_bar.color.set(0, 1.0, 0)
      @title_bar.position.z = 2
      @items = {}
    end

    #
    # Create Button
    # @param options [Hash] (x, y, z, w, h, title, font_size, name)
    #
    # @return [type] [description]
    def create_button( opts = {} )
      b = Button.new( opts )
      b.z = 2
      @items[opts[:name]] = b
      return b
    end

    #
    # Create Edit
    # @param options [Hash] (x, y, z, w, h, value, font_size, name)
    #
    # @return [type] [description]
    def create_edit( opts = {})
      e = Edit.new( opts )
      e.z = 2
      @items[opts[:name]] = e
      return e
    end

    #
    # [create_label description]
    # @param options [Hash] (x, y, z, w, h, title)
    #
    # @return [BBText] Created label object
    def create_label( opts = {} )
      text = Text.new( opts )
      text.h = opts[:h] || 13
      text.position.x = opts[:x]
      text.position.y = opts[:y]
      text.d = 2
      @items[opts[:name]] = text
      return text
    end

    #
    # Mouse event handler
    # @param x [Integer] Cursor X Position
    # @param y [Integer] Cursor Y Position
    # @param right_b [Integer] Right Mouse Button
    # @param left_b [Integer] Left Mouse Button
    # @param middle_b [Integer] Middle Mouse Button
    #
    def mouse(x, y, right_b, left_b, middle_b)
      @items.each do |name, item|
        if item.respond_to?(:mouse)
          item.mouse(x - @x, y - @y, right_b, left_b, middle_b)
        end
      end
    end

    #
    # Render Function
    #
    def render
      options = {
        x: @x, y: @y, z: 1 / (10000 - @z.to_f),
        width: @w, height: @h,
        color: BlackBook::CVector.new(1.0, 1.0, 1.0, 0.8),
        border: true, border_color: BlackBook::CVector.new(218, 112, 214),
        border_size: 3
      }
      BlackBook.draw_box_2d(options)
      GL.PushMatrix
      GL.Translatef(@x, @y, 1 / (10000 - @z.to_f))
      @title_bar.render
      @items.each do |name, item|
        item.render
      end
      GL.PopMatrix
    end
  end
end

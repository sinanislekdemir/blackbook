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

module UI
  # BB Ui Element Base Class
  class UiElement < BlackBook::Base
    attr_accessor :x, :y, :z, :w, :h, :title

    def initialize( opts = {} )
      super
      @x = opts[:x] if opts[:x]
      @y = opts[:y] if opts[:y]
      @z = opts[:z] if opts[:z]
      @w = opts[:w] if opts[:w]
      @h = opts[:h] or 35
      @title = opts[:title] if opts[:title]
    end
  end
end

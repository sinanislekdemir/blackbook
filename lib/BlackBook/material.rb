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
require 'BlackBook/constants'

# BlackBook Material
module BlackBook
  # BlackBook Material
  class Material
    attr_writer :color, :texture_data
    attr_accessor :color, :texture_data

    # Initialize material
    def initialize
      @color = CVector.new(1.0, 1.0, 1.0, 1.0)
    end

    # Render material
    def start_render
      GL.Enable(GL::COLOR_MATERIAL)
      GL.Enable(GL::BLEND)
      GL.BlendFunc(GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA)
      GL.Color4f(@color.x, @color.y, @color.z, @color.w)
    end

    # End Material
    def end_render
      GL.Disable(GL::BLEND)
      GL.Disable(GL::COLOR_MATERIAL)
    end
  end
end

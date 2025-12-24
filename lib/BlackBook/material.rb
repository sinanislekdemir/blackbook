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
require 'mini_magick'
require 'BlackBook/base'
require 'BlackBook/constants'

# BlackBook Material
module BlackBook
  # BlackBook Material
  class Material
    attr_accessor :color, :texture_data, :image_w, :image_h

    # Initialize material
    def initialize
      @color = CVector.new(1.0, 1.0, 1.0, 1.0)
      @image_w = 0
      @image_h = 0
      @texture_file = ''
      @loaded = false
    end

    def load_texture(filename)
      @texture_file = filename
    end

    def texture(filename)
      image = MiniMagick::Image.open(filename)
      @image_w = image.width
      @image_h = image.height
      
      # Export pixels as RGBA using ImageMagick
      rgba_data = image.get_pixels('RGBA')
      # Flatten the 2D array of pixels and convert to byte array
      @texture_data = rgba_data.flatten
      
      @tex = GL::GenTextures(1)
      GL.BindTexture(GL::TEXTURE_2D, @tex[0])
      GL.TexParameteri(GL::TEXTURE_2D, GL::TEXTURE_WRAP_S, GL::CLAMP)
      GL.TexParameteri(GL::TEXTURE_2D, GL::TEXTURE_WRAP_T, GL::CLAMP)
      GL.TexParameteri(GL::TEXTURE_2D, GL::TEXTURE_MAG_FILTER, GL::NEAREST)
      GL.TexParameteri(GL::TEXTURE_2D, GL::TEXTURE_MIN_FILTER, GL::NEAREST)
      GL.TexImage2D(
        GL::TEXTURE_2D, 0, GL::RGBA, @image_w,
        @image_h, 0, GL::RGBA, GL::UNSIGNED_BYTE, @texture_data.pack('C*')
      )
      @loaded = true
    end

    # Render material
    def start_render
      texture(@texture_file) if @loaded == false && !@texture_file.empty?

      if @image_w + @image_h > 0
        GL.Enable(GL::TEXTURE_2D)
        GL.BindTexture(GL::TEXTURE_2D, @tex[0])
      else
        GL.Enable(GL::COLOR_MATERIAL)
        GL.Enable(GL::BLEND)
        GL.BlendFunc(GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA)
        GL.Color4f(@color.x, @color.y, @color.z, @color.w)
      end
    end

    # End Material
    def end_render
      if @image_w + @image_h > 0
        GL.Disable(GL::TEXTURE_2D)
      else
        GL.Disable(GL::BLEND)
        GL.Disable(GL::COLOR_MATERIAL)
      end
    end
  end
end

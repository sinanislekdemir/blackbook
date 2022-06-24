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
require 'BlackBook/constants'
require 'BlackBook/base'
require 'ui/ui_element'

module UI
  #
  # BBChar Item - Holds 3D Vertex data for a character
  #
  # @attr index [Integer] OpenGL ListIndex
  # @attr char [String] Character
  # @attr width [Float] Char Width
  # @attr font_path [String] Path to font files
  # @attr faces [Array] Vertice Array for Faces
  # @attr position [CVector] Position Vector
  # @attr min [CVector] Min. Vertice
  # @attr max [CVector] Max. Vertice
  # @author [sinan islekdemir]
  #
  class Char < BlackBook::Base
    attr_accessor :index, :char, :width, :font_path, :faces, :position,
                  :min, :max

    #
    # Initialize character
    #
    # @return [Boolean] Success
    def initialize
      @index = -1
      @position = BlackBook::CVector.new(0, 0, 0, 1)
      @faces = []
      @min = nil
      @max = nil
      super
    end

    #
    # Add Face to Character Object
    # @param vertex_array [Array] Array of vertices (raw file format)
    #
    # @return [Boolean] Success
    def add_face(vertex_array)
      @faces.push(vertex_array)
      return true
    end

    def get_width
      @width = 0.0
      min_x = 9e10
      min_y = 9e10
      min_z = 9e10
      max_x = -9e10
      max_y = -9e10
      max_z = -9e10
      @faces.each do |face|
        dx = [face[0], face[3], face[6]].minmax
        dy = [face[1], face[4], face[7]].minmax
        dz = [face[2], face[5], face[8]].minmax
        min_x = dx[0] if dx[0] < min_x
        min_y = dy[0] if dy[0] < min_y
        min_z = dz[0] if dz[0] < min_z
        max_x = dx[1] if dx[1] > max_x
        max_y = dy[1] if dy[1] > max_y
        max_z = dz[1] if dz[1] > max_z
      end
      @width = max_x - min_x
    end

    #
    # Build OpenGL Display List
    #
    # @return [Float] Char Width
    def build_list
      @index = GL.GenLists(1)
      @width = 0.0
      min_x = 9e10
      min_y = 9e10
      min_z = 9e10
      max_x = -9e10
      max_y = -9e10
      max_z = -9e10
      v1 = BlackBook::CVector.new(0, 0, 0, 1)
      v2 = BlackBook::CVector.new(0, 0, 0, 1)
      v3 = BlackBook::CVector.new(0, 0, 0, 1)
      GL.NewList(@index, GL::COMPILE)
      GL.LineWidth(2)
      @faces.each do |face|
        vertex_count = face.count / 3
        v1.x = face[0]
        v1.y = face[1]
        v1.z = face[2]
        v2.x = face[3]
        v2.y = face[4]
        v2.z = face[5]
        v3.x = face[6]
        v3.y = face[7]
        v3.z = face[8]
        dx = [face[0], face[3], face[6]].minmax
        dy = [face[1], face[4], face[7]].minmax
        dz = [face[2], face[5], face[8]].minmax
        min_x = dx[0] if dx[0] < min_x
        min_y = dy[0] if dy[0] < min_y
        min_z = dz[0] if dz[0] < min_z
        max_x = dx[1] if dx[1] > max_x
        max_y = dy[1] if dy[1] > max_y
        max_z = dz[1] if dz[1] > max_z
        normal = BlackBook.calc_plane_normal(v1, v2, v3)
        GL.Begin(GL::TRIANGLES)
        1.upto(vertex_count) do |index|
          i = (index - 1) * 3
          GL.Normal3f(normal.x, normal.y, normal.z)
          GL.Vertex3f(face[i], face[i + 1], face[i + 2])
        end
        GL.End
      end
      GL.EndList
      @width = max_x - min_x
    end

    #
    # Load Character from file and build display list
    # @param c [String] Character to load
    # @param build_list [boolean] Build list?
    #
    # @return [Float] Character width
    def load_char(c, build_lists = false)
      filename = @font_path + '/' + c.ord.to_s + '.raw'
      file = File.open(filename, 'r')
      file.each_line do |line|
        items = line.split(' ')
        f_items = []
        items.each do |item|
          f_items.push item.to_f
        end
        add_face f_items
      end
      @char = c
      get_width
      build_list if build_lists
    end

    #
    # Render Function
    #
    def render
      build_list if @index == -1
      GL.CallList(@index)
    end
  end

  #
  # BBText Object. Suitable for both 2D and 3D Rendering
  #
  # @attr font [Hash] Font char hash
  # @attr position [CVector] Position of text
  # @attr roll [Float] Roll angle in degrees
  # @attr yaw [Float] Yaw angle in degrees
  # @attr pitch [Float] Pitch angle in degrees
  # @attr scale [Float] Scale factor
  # @attr d [Integer] 2 - Draw in 2D | 3 - Draw in 3D
  # @attr text [String] Text to render
  # @attr color [CVector] Color of text
  # @attr gl_active [Boolean] OpenGL Initialized and activated
  #
  # @author [sinan]
  #
  class Text < UiElement
    attr_accessor :font, :position, :roll, :pitch, :yaw, :scale, :d, :text,
                  :color, :gl_active

    #
    # Initialize BBText
    # @param options [Hash] (x, y, z, w, h, title)
    #
    # @return [type] [description]
    def initialize( opts = {} )
      super
      @d = 3
      @text = opts[:title]
      @font = {}
      @position = BlackBook::CVector.new(0, 0, 0, 1)
      @scale = BlackBook::CVector.new(1, 1, 1, 1)
      @scale.multiply(opts[:h] || 13)
      @color = BlackBook::CVector.new(1, 1, 1, 1)
      @roll  = 0.0
      @pitch = 0.0
      @yaw   = 0.0
      @gl_active = false
      data_path = BlackBook::Registry.instance.read('data_path') || './data'
      chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' \
              '01234567890!\'^+%&/()=?-_.'
      chars.each_char do |c|
        bb_char = Char.new
        bb_char.font_path = data_path + '/font'
        bb_char.load_char c
        @font[c] = bb_char
      end
    end

    #
    # Total width of the text
    #
    # @return [Float] Width
    def width
      w = 0.0
      @text.each_char do |c|
        w += 0.5 if c == ' '
        w += @font[c].width + 0.1 if @font.key?(c)
      end
      w * @scale.x
    end

    #
    # Render Function
    #
    def render
      if @gl_active == false
        @font.each do |k, f|
          f.build_list
        end
        @gl_active = true
      end

      GL.PushMatrix
      GL.Disable(GL::LIGHTING)
      GL.Enable(GL::COLOR_MATERIAL)
      GL.Color3f(@color.x, @color.y, @color.z)

      GL.Translate(
        @position.x,
        @position.y,
        @d == 2 ? 1 / (10000 - @position.z.to_f) : @position.z
      )

      total_forward = 0

      GL.Rotate(@d == 2 ? 180 : @roll, 1, 0, 0)
      GL.Rotate(@pitch, 0, 1, 0)
      GL.Rotate(@yaw, 0, 0, 1)
      GL.Scalef(@scale.x, @scale.y, @scale.z)

      @text.each_char do |c|
        GL.Translate(0.5, 0, 0) if c == ' '
        total_forward += 0.5 if c == ' '
        if c == "\n"
          GL.Translate(-1 * total_forward, 1, 0)
          total_forward = 0
        end
        if @font.key?(c)
          @font[c].render
          GL.Translate(@font[c].width + 0.1, 0, 0)
          total_forward += @font[c].width + 0.1
        end
      end
      GL.PopMatrix
      GL.Enable(GL::LIGHTING)
    end
  end
end

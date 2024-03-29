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
require 'pp'

# Local Libs
require 'BlackBook/base'
require 'BlackBook/functions'

module BlackBook
  #
  # Camera Class
  # @attr eye_position [CVector] Eye - Camera position
  # @attr target [CVector] Camera target
  # @attr up_vector [CVector] Camera Up Vector
  # @attr frame_x [Integer] Camera Frame X Location
  # @attr frame_y [Integer] Camera Frame Y Location
  # @attr frame_width [Integer] Camera Frame Width
  # @attr frame_height [Integer] Camera Frame Height
  # @attr fov [Float] Camera Field Of View
  # @attr znear [Float] Near Plane Distance
  # @attr zfar [Float] Far Plane Distance
  # @attr on_update [Array] [0] -> Lambda | [1] -> Variable Array
  #   Your Lambda function MUST include 4 arguements like;
  #   on_update = -> (camera, x, y, extra_array_to_pass) { ... }
  #
  # @author [sinan islekdemir]
  #
  class Camera < Base
    attr_accessor :eye_position, :target, :up_vector, :frame_x, :frame_y,
                  :frame_width, :frame_height, :fov, :znear, :zfar, :on_update

    # options -> :eye_position, :target_position, :up, :fov, :znear, :zfar
    #            :frame_x, :frame_y, :frame_width, :frame_height

    #
    # Initialize Camera
    # @param options [Hash]
    #                :eye_position
    #                :target
    #                :up_vector
    #                :frame_x
    #                :frame_y
    #                :frame_width
    #                :frame_height
    #                :fov
    #                :znear
    #                :zfar
    #                :on_update
    #
    # @return [type] [description]
    def initialize( opts = {} )
      super
      @eye_position = CVector.new(
        opts[:eye_position].x,
        opts[:eye_position].y,
        opts[:eye_position].z
      )
      @target = CVector.new(
        opts[:target_position].x,
        opts[:target_position].y,
        opts[:target_position].z
      )
      @up_vector = CVector.new(
        opts[:up].x,
        opts[:up].y,
        opts[:up].z
      )
      @on_update = nil
      @frame_x   = opts[:frame_x] || 0
      @frame_y   = opts[:frame_y] || 0
      @frame_width  = opts[:frame_width]  || 0
      @frame_height = opts[:frame_height] || 0
      @fov   = opts[:fov]   || 30.0
      @znear = opts[:znear] || 1.0
      @zfar  = opts[:zfar]  || 1000.0
      @modified = false
    end

    #
    # Turn screen coordinates to world coordinates
    # @param x [Integer] Cursor X
    # @param y [Integer] Cursor Y
    #
    # @return [CVector] World position
    def screen_to_world(x, y)
      mv = GL.GetFloatv GL::MODELVIEW_MATRIX
      pm = GL.GetFloatv GL::PROJECTION_MATRIX
      vp = GL.GetFloatv GL::VIEWPORT
      y = vp[3] - y
      z = GL.ReadPixels(x, y, 1, 1, GL::DEPTH_COMPONENT, GL::FLOAT)
      z = z.unpack('f')[0]
      glh_unprojectf(x, y, z, mv, pm, vp)
    end

    #
    # World to screen coordinates
    # @param v [CVector] World coordinates
    #
    # @return [Array] Array of screen coordinates
    def world_to_screen(v)
      mv = GL.GetFloatv GL::MODELVIEW_MATRIX
      pm = GL.GetFloatv GL::PROJECTION_MATRIX
      vp = GL.GetFloatv GL::VIEWPORT
      BlackBook.glh_project_f(v, mv, pm, vp)
    end

    #
    # Is camera framed?
    #
    # @return [Boolean] Is camera framed?
    def framed
      (@frame_width > 0 && @frame_height > 0)
    end

    #
    # Begin rendering
    #
    # @return [Boolean] Success
    def begin_render
      if @frame_width > 0 && @frame_height > 0
        GL.PushAttrib(GL::SCISSOR_BIT)
        GL.Enable(GL::SCISSOR_TEST)
        GL.Scissor(@frame_x, @frame_y, @frame_width, @frame_height)
        GL.Viewport(@frame_x, @frame_y, @frame_width, @frame_height)
        BlackBook.perspective(
          30.0, @frame_width.to_f / @frame_height.to_f, 1.0, 1000.0
        )
      end
      GL.LoadIdentity
      BlackBook.look_at(
        @eye_position,
        @target,
        @up_vector)
      true
    end

    #
    # End Rendering
    #
    # @return [Boolean] Success
    def end_render
      if @modified && !@on_update.nil?
        lambda = @on_update[0]
        variable = @on_update[1]
        lambda.call(self, @pos_x, @pos_y, variable)
        @modified = false
      end
      return false until framed
      GL.Disable(GL::SCISSOR_TEST)
      GL.PopAttrib
      return true
    end

    #
    # Mouse event handler
    # @param x [Integer] Cursor X Position
    # @param y [Integer] Cursor Y Position
    # @param right_b [Integer] Right Mouse Button
    # @param left_b [Integer] Left Mouse Button
    # @param middle_b [Integer] Middle Mouse Button
    #
    def mouse_move(x, y, _right_b, left_b, _middle_b)
      @pos_x, @pos_y = x, y if @pos_x.nil?
      if left_b == 1
        diff = @eye_position.sub(@target)
        diff.update_spherical
        diff.phi = diff.phi - BlackBook.deg_to_rad((x.to_f - @pos_x.to_f).to_f)
        diff.theta = diff.theta - BlackBook.deg_to_rad(
          (y.to_f - @pos_y.to_f).to_f
        )
        diff.update_cartesian
        @eye_position = @target.add(diff)
        @modified = true
      end
      @pos_x, @pos_y = x, y
    end
  end
end

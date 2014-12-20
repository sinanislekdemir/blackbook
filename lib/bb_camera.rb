################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'pp'

# Local Libs
require 'bb_base'
require 'bb_functions'

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
#
# @author [sinan islekdemir]
#
class BBCamera < BBBase
  attr_accessor :eye_position, :target, :up_vector, :frame_x, :frame_y,
                :frame_width, :frame_height, :fov, :znear, :zfar, :on_update
  attr_writer :eye_position, :target, :up_vector, :frame_x, :frame_y,
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
  def initialize(options)
    super
    @eye_position = CVector.new(
      options[:eye_position].x,
      options[:eye_position].y,
      options[:eye_position].z
      )
    @target = CVector.new(
      options[:target_position].x,
      options[:target_position].y,
      options[:target_position].z
      )
    @up_vector = CVector.new(
      options[:up].x,
      options[:up].y,
      options[:up].z
      )
    @on_update = nil
    @frame_x = options.key?(:frame_x) ? options[:frame_x] : 0
    @frame_y = options.key?(:frame_y) ? options[:frame_y] : 0
    @frame_width = options.key?(:frame_width) ? options[:frame_width] : 0
    @frame_height = options.key?(:frame_height) ? options[:frame_height] : 0
    @fov = options.key?(:fov) ? options[:fov] : 30.0
    @znear = options.key?(:znear) ? options[:znear] : 1.0
    @zfar = options.key?(:zfar) ? options[:zfar] : 1000.0
  end

  def screen_to_world(x, y)
    mv = GL.GetFloatv GL::MODELVIEW_MATRIX
    pm = GL.GetFloatv GL::PROJECTION_MATRIX
    vp = GL.GetFloatv GL::VIEWPORT
    glh_unprojectf(x, y, 1, mv, pm, vp)
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
      draw_box_2d(
        x: @frame_x,
        y: @frame_y,
        z: 0.1,
        height: @frame_height,
        width: @frame_width,
        border: true,
        border_color: CVector.new(255, 255, 255, 1),
        border_size: 2.0,
        color: CVector.new(0, 0, 0, 0)
        )
      GL.PushAttrib(GL::SCISSOR_BIT)
      GL.Enable(GL::SCISSOR_TEST)
      GL.Scissor(@frame_x, @frame_y, @frame_width, @frame_height)
      GL.Viewport(@frame_x, @frame_y, @frame_width, @frame_height)
    end
    GL.LoadIdentity
    look_at(
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
    return false until framed
    GL.Disable(GL::SCISSOR_TEST)
    GL.PopAttrib
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
  def mouse_move(x, y, _right_b, left_b, _middle_b)
    @pos_x, @pos_y = x, y if @pos_x.nil?
    if left_b == 1
      diff = @eye_position.sub(@target)
      diff.update_spherical
      diff.phi = diff.phi - deg_to_rad((x.to_f - @pos_x.to_f).to_f)
      diff.theta = diff.theta - deg_to_rad((y.to_f - @pos_y.to_f).to_f)
      diff.update_cartesian
      @eye_position = @target.add(diff)
      unless @on_update.nil?
        lambda = @on_update[0]
        variable_array = @on_update[1]
        variable_array.insert(0, self)
        variable_array.insert(1, x)
        variable_array.insert(2, y)
        lambda.call variable_array
      end
    end
    @pos_x, @pos_y = x, y
  end
end

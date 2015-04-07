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

require 'BlackBook/base'
require 'BlackBook/functions'

module BlackBook
  #
  # CVector Class (From Dust Engine by Sinan ISLEKDEMIR)
  #
  # @author [sinan islekdemir]
  #
  # @attr x [Float] Vector - X magnitude
  # @attr y [Float] Vector - Y magnitude
  # @attr z [Float] Vector - Z magnitude
  # @attr w [Float] Vector - W
  # @attr phi [Float] Phi - Spherical Coordinates
  # @attr theta [Float] Theta - Spherical Coordinates
  # @attr r [Float] Radius - Spherical Coordinates
  class CVector < Base
    # phi dikey, theta yatay aci| r orijine mesafe - yaricap
    attr_accessor :x, :y, :z, :w, :phi, :theta, :r
    attr_writer :x, :y, :z, :w, :phi, :theta, :r

    #
    # Initialize Vector
    # @param x [Float] X
    # @param y [Float] Y
    # @param z [Float] Z
    # @param w = 1 [Float] W
    #
    # @return [Boolean] Success
    def initialize(x, y, z, w = 1)
      super
      @x = x
      @y = y
      @z = z
      @w = w
      update_spherical
      true
    end

    #
    # Scalar Multiply Vector with a factor float
    # @param factor [Float] Multiplication Float
    def multiply(factor)
      @x *= factor
      @y *= factor
      @z *= factor
    end

    #
    # Scalar Division Vector with a factor float
    # @param [Float] Division Float
    def div(factor)
      @x /= factor
      @y /= factor
      @z /= factor
    end

    #
    # Set Vector
    # @param x [Float] X Magnitude
    # @param y [Float] Y Magnitude
    # @param z [Float] Z Magnitude
    # @param w = 1 [Float] W Magnitude
    #
    # @return [CVector] Self
    def set(x, y, z, w = 1)
      @x, @y, @z, @w = x, y, z, w
    end

    #
    # Update Spherical Coordinates
    #
    # @return [Boolean] Success
    def update_spherical
      @r = length
      @theta = Math.acos(@z / r)
      @phi = Math.atan2(@y, @x)
      true
    end

    #
    # Update Cartesian Coordinates
    #
    # @return [Boolean] Success
    def update_cartesian
      @x = @r * Math.sin(@theta) * Math.cos(@phi)
      @y = @r * Math.sin(@theta) * Math.sin(@phi)
      @z = @r * Math.cos(@theta)
      true
    end

    #
    # Normalize Vector
    #
    # @return [Boolean] Success
    def normalize
      d = length
      d = d < 0 ? -1 * d : d
      @x /= d
      @y /= d
      @z /= d
      self
    end

    #
    # Calculate Vector Length
    #
    # @return [Float] Length of vector
    def length
      Math.sqrt((@x * @x) + (@y * @y) + (@z * @z))
    end

    #
    # Vector Cross Product
    # @param vector [CVector] Multiplication Vector
    #
    # @return [CVector] Product Vector
    def cross(vector)
      CVector.new(
        @y * vector.z - @z * vector.y,
        @z * vector.x - @x * vector.z,
        @x * vector.y - @y * vector.x,
        0
      )
    end

    #
    # Vector Dot Product
    # @param vector [CVector] Multiplication Vector
    #
    # @return [Float] Dot Product
    def dot(vector)
      @x * vector.x + @y * vector.y + @z * vector.z + @w * vector.w
    end

    #
    # Distance between two vectors
    # @param vector [CVector] Target Vector
    #
    # @return [Float] Distance
    def distance(vector)
      diff = sub(vector)
      diff.length
    end

    #
    # Rotate Vector around X Axis
    # @param angle [Float] Angle in Degrees
    #
    # @return [Boolean] Success
    def rotate_around_x(angle)
      angle = angle * Math::PI / 180
      s = Math.sin(angle)
      c = Math.cos(angle)
      @y = c * @y + s * @z
      @z = c * @z - s * @y
      true
    end

    #
    # Rotate Vector around Y Axis
    # @param angle [Float] Angle in Degrees
    #
    # @return [Float] Success
    def rotate_around_y(angle)
      angle = angle * Math::PI / 180
      s = Math.sin(angle)
      c = Math.cos(angle)
      @x = c * @x + s * @z
      @z = c * @z - s * @x
      true
    end

    #
    # Rotate Vector around Z Axis
    # @param angle [Float] Angle in Degrees
    #
    # @return [Float] Success
    def rotate_around_z(angle)
      angle = angle * Math::PI / 180
      s = Math.sin(angle)
      c = Math.cos(angle)
      @x = c * @x + s * @y
      @y = c * @y - s * @x
      true
    end

    #
    # Vector Subtraction
    # @param v [CVector] Target Vector
    #
    # @return [CVector] Result
    def sub(v)
      CVector.new(@x - v.x, @y - v.y, @z - v.z, @w)
    end

    #
    # Vector Addition
    # @param v [CVector] Addition Vector
    #
    # @return [CVector] Result
    def add(v)
      CVector.new(@x + v.x, @y + v.y, @z + v.z, @w)
    end

    #
    # Convert CVector into one dimensional array
    #
    # @return [type] [description]
    def to_array
      [x, y, z, w]
    end
  end

  # CMatrix Class
  class CMatrix
    attr_writer :left, :dir, :up, :pos
    attr_accessor :left, :dir, :up, :pos

    # initialize
    def initialize
      @left = CVector.new(1.0, 0.0, 0.0, 0.0)
      @dir  = CVector.new(0.0, 1.0, 0.0, 0.0)
      @up   = CVector.new(0.0, 0.0, 1.0, 0.0)
      @pos  = CVector.new(0.0, 0.0, 0.0, 1.0)
    end

    def to_array
      m = [left.to_array, dir.to_array, up.to_array, pos.to_array]
      m.flatten
    end

    def rotate(x, y, z)
      m = to_array
      x = BlackBook.deg_to_rad x
      y = BlackBook.deg_to_rad y
      z = BlackBook.deg_to_rad z
      m[12] = 0.0
      m[13] = 0.0
      m[14] = 0.0
      unified = [
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
      ]
      x_matrix = unified.clone
      x_matrix[5] = Math.cos y
      x_matrix[6] = -1 * Math.sin(y)
      x_matrix[9] = Math.sin y
      x_matrix[10] = Math.cos y
      y_matrix = unified.clone
      y_matrix[0] = Math.cos x
      y_matrix[2] = Math.sin x
      y_matrix[8] = -1 * Math.sin(x)
      y_matrix[10] = Math.cos x
      z_matrix = unified.clone
      z_matrix[0] = Math.cos z
      z_matrix[1] = -1 * Math.sin(z)
      z_matrix[4] = Math.sin z
      z_matrix[5] = Math.cos z
      m_1 = BlackBook.multiply_matrices_4by4 m, x_matrix
      m_2 = BlackBook.multiply_matrices_4by4 m_1, y_matrix
      m_3 = BlackBook.multiply_matrices_4by4 m_2, z_matrix
      m_3[12], m_3[13], m_3[14] = @pos.x, @pos.y, @pos_z
      @left.set m_3[0], m_3[1], m_3[2], m_3[3]
      @dir.set m_3[4], m_3[5], m_3[6], m_3[7]
      @up.set m_3[8], m_3[9], m_3[10], m_3[11]
      m_3
    end
  end

  # Acceleration class
  class CAcceleration
    attr_writer :vector, :start, :end, :name, :direction
    attr_accessor :vector, :start, :end, :name, :direction
    LINEAR = 0
    ANGULAR = 1

    # Direction 0 - linear | 1 - angular
    def initialize(vector, name = '', start_time = 0, end_time = 0, d = 0)
      @vector = vector
      @name = name
      @start = start_time
      @end = end_time
      @direction = d
    end
  end

  # Velocity class
  class CVelocity
    attr_writer :vector, :start, :end, :name, :direction
    attr_accessor :vector, :start, :end, :name, :direction
    LINEAR = 0
    ANGULAR = 1

    # Direction 0 - linear | 1 - angular
    def initialize(vector, name = '', start_time = 0, end_time = 0, d = 0)
      @vector = vector
      @name = name
      @start = start_time
      @end = end_time
      @direction = d
    end
  end
end

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'BlackBook/base'

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
      true
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

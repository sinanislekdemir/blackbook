################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'pp'

# Local Libs
require 'bb_3dobject'

# 3D Space Object
class BBSpaceObject < BB3DObject
  attr_writer :faces, :mass, :kinetic_energy, :potential,
              :roll, :pitch, :yaw, :position, :type, :time,
              :name, :scale,
              :angular_velocity, :angular_acceleration,
              :linear_velocity, :linear_acceleration
  attr_accessor :faces, :mass, :kinetic_energy, :potential,
                :roll, :pitch, :yaw, :position, :type, :time,
                :name, :scale, :acceleration,
                :angular_velocity, :angular_acceleration,
                :linear_velocity, :linear_acceleration

  PARTICLE = 0
  SOLID_CUBE = 1
  SOLID_SPHERE = 2
  SOLID_MESH = 3
  SOFT_CUBE = 4
  SOFT_SPHERE = 5
  SOFT_MESH = 6

  # constructor
  def initialize
    super
    @faces = []
    @kinetic_energy = 0.0
    @potential = 0.0
    @type = PARTICLE
    @angular_velocity = CVelocity.new(CVector.new(0, 0, 0, 1))
    @angular_acceleration = CAcceleration.new(CVector.new(0, 0, 0, 1))
    @linear_acceleration = CAcceleration.new(CVector.new(0, 0, 0, 1))
    @linear_velocity = CVelocity.new(CVector.new(0, 0, 0, 1))
  end

  def load_type(data)
    @type = data['type'] if data.key?('type')
  end

  def load_linear_velocity(data)
    return unless data.key?('linear_velocity')
    @linear_velocity.vector.x = data['linear_velocity'][0]
    @linear_velocity.vector.y = data['linear_velocity'][1]
    @linear_velocity.vector.z = data['linear_velocity'][2]
  end

  def load_linear_acceleration(data)
    return unless data.key?('linear_acceleration')
    @linear_acceleration.vector.x = data['linear_acceleration'][0]
    @linear_acceleration.vector.y = data['linear_acceleration'][1]
    @linear_acceleration.vector.z = data['linear_acceleration'][2]
  end

  def load_angular_velocity(data)
    return unless data.key?('angular_velocity')
    @angular_velocity.vector.x = data['angular_velocity'][0]
    @angular_velocity.vector.y = data['angular_velocity'][1]
    @angular_velocity.vector.z = data['angular_velocity'][2]
  end

  def load_angular_acceleration(data)
    return unless data.key?('angular_acceleration')
    @angular_acceleration.vector.x = data['angular_acceleration'][0]
    @angular_acceleration.vector.y = data['angular_acceleration'][1]
    @angular_acceleration.vector.z = data['angular_acceleration'][2]
  end

  def load(data)
    super
    load_type data
    load_linear_velocity data
    load_linear_acceleration data
    load_angular_velocity data
    load_angular_acceleration data
    case @type
    when 1
      create_cube
    when 2
      create_sphere
    when 3
      load_raw data['filename']
    end
    x, y, z = data['scale'][0], data['scale'][1], data['scale'][2]
    @scale.set(x, y, z) if data.key?('scale')
  end
end

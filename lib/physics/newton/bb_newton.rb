################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'bb_space_object'
require 'physics/bb_physics'
require 'physics/newton/bb_newton_module'
require 'bb_functions'

# Newtonian physics
class BBNewton < BBPhysics
  attr_accessor :ground_plane, :start, :duration, :keys
  attr_writer :ground_plane, :start, :duration, :keys

  def initialize
    super
    @ground_plane = nil
  end

  # calculate positions for given miliseconds
  def calculate_time(miliseconds)
    return false if miliseconds == 0
  end

  def apply_acceleration(acceleration_vector)
  end

  def apply_angular_acceleration(acceleration_vector)
  end

  def apply_variables
    super
    @variables.each do |variable|
    end
  end

  def load_constant(data)
    name = 'const_' + @variables.count.to_s
    t_start = 0
    t_end = 0
    name = data['name'] if data.key?('name')
    t_start = data['start'] if data.key?('start')
    t_end = data['end'] if data.key?('end')
    m = array_to_vector(data['magnitude'])
    case data['type']
    when 'linear_velocity'
      v = CVelocity.new(m, name, t_start, t_end, CVelocity::LINEAR)
    when 'linear_acceleration'
      v = CAcceleration.new(m, name, t_start, t_end, CAcceleration::LINEAR)
    when 'angular_velocity'
      v = CVelocity.new(m, name, t_start, t_end, CVelocity::ANGULAR)
    when 'angular_acceleration'
      v = CAcceleration.new(m, name, t_start, t_end, CAcceleration::ANGULAR)
    end

    @variables.push v
  end

  def load_keys(data)
    return unless data.key?('keys')
  end

  def load(data)
    data['items'].each do |item|
      obj = BBSpaceObject.new
      obj.load item
      @items[item['name']] = obj
    end
    data['constants'].each do |constant|
      load_constant constant
    end
  end
end

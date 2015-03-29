################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'BlackBook/b3dobject'
require 'BlackBook/functions'
require 'BlackBook/physics/physics'
require 'json'

module BlackBook
  class Newton < Physics
    attr_accessor :ground_plane, :start, :duration, :keys, :space
    attr_writer :ground_plane, :start, :duration, :keys, :space

    # Gravitational Constant
    G = 6.67e-11
    MASS_EARTH = 5.97219e24
    RADIUS_EARTH = 6378100

    def initialize(space)
      super
      @space = space
      @ground_plane = nil
      @variables = []
    end

    # calculate positions for given miliseconds
    def calculate_time(miliseconds)
      return false if miliseconds == 0
    end

    def add_variable(const)
      @variables << const
    end

    # v = acceleration * time + initial velocity
    def velocity(a, t, vi = 0)
      # (a * t) + vi
      result = a.clone
      result.multiply(t)
      result.add(vi)
      result
    end

    # position = initial position + (initial vel. * time) + (a * t^2) / 2
    def position_acceleration(a, t, vi = 0, ri)
      result = CVector.new(0, 0, 0)
      result.x = ri.x + (vi.x * t) + (a.x * (t**2) / 2)
      result.y = ri.y + (vi.x * t) + (a.x * (t**2) / 2)
      result.z = ri.z + (vi.x * t) + (a.x * (t**2) / 2)
      result
    end

    # position = initial position + vel * init. vel / 2 * time
    def position(v, t, vi, ri)
      # ri + (((v + vi) / 2) * t)
      result = CVector.new(0, 0, 0)
      result.x = ri.x + (((v.x + vi.x) / 2) * t)
      result.y = ri.y + (((v.y + vi.y) / 2) * t)
      result.z = ri.z + (((v.z + vi.z) / 2) * t)
      result
    end

    def timeless_velocity(a, r, ri, vi)
      # Math.sqrt((vi**2) + (2 * a * (r - ri)))
      result = CVector.new(0, 0, 0)
      result.x = Math.sqrt((vi.x ** 2) + (2 * a.x * (r.x - ri.x)))
      result.y = Math.sqrt((vi.y ** 2) + (2 * a.y * (r.y - ri.y)))
      result.z = Math.sqrt((vi.z ** 2) + (2 * a.z * (r.z - ri.z)))
      result
    end

    def circular_velocity(a, t, wi = 0)
      # wi + (a * t)
      result = CVector.new(0, 0, 0)
      result.x = wi + (a.x * t)
      result.y = wi + (a.y * t)
      result.z = wi + (a.z * t)
      result
    end

    def angular_displacement(theta, a, t, wi = 0)
      result = CVector.new(0, 0, 0)
      result.x = theta + (wi * t) + (0.5 * a.x * (t**2))
      result.y = theta + (wi * t) + (0.5 * a.y * (t**2))
      result.z = theta + (wi * t) + (0.5 * a.z * (t**2))
      # theta + (wi * time) + (0.5 * a * (t**2))
      result
    end

    def angular_displacement_2(theta, wi, w, time)
      result = CVector.new(0, 0, 0)
      result.x = theta + (0.5 * (wi + w.x) * time)
      result.y = theta + (0.5 * (wi + w.y) * time)
      result.z = theta + (0.5 * (wi + w.z) * time)
      # theta + (0.5 * (wi + w) * t)
      result
    end

    def kinetic_energy(m, v)
      # 0.5 * m * (v**2)
      result = CVector.new(0, 0, 0)
      result.x = 0.5 * m * (v.x**2)
      result.y = 0.5 * m * (v.y**2)
      result.z = 0.5 * m * (v.z**2)
      result
    end

    def potential_energy(m, g, h)
      result = CVector.new(0, 0, 0)
      # m * g * h
      result.x = m * g.x * h
      result.y = m * g.y * h
      result.z = m * g.z * h
      result
    end

    def gravity(m1, m2, dist)
      G * (m1 * m2 / (dist**2))
    end

    # Get appied linear acceleration on object
    def get_linear_acceleration(obj)
      result = CVector.new(0, 0, 0)
      @variables.each do |variable|
        next unless variable.is_a? CAcceleration
        next unless variable.direction == CAcceleration::LINEAR
        result.x += variable.vector.x
        result.y += variable.vector.y
        result.z += variable.vector.z
      end
      result.x += obj.linear_acceleration.vector.x
      result.y += obj.linear_acceleration.vector.y
      result.z += obj.linear_acceleration.vector.z
      result
    end

    # Get applied linear veloctiy on object
    def get_linear_velocty(obj)
      result = CVector.new(0, 0, 0)
      @variables.each do |variable|
        next unless variable.is_a? CVelocity
        next unless variable.direction == CVelocity::LINEAR
        result.x += variable.vector.x
        result.y += variable.vector.y
        result.z += variable.vector.z
      end
      result.x += obj.linear_velocity.vector.x
      result.y += obj.linear_velocity.vector.y
      result.z += obj.linear_velocity.vector.z
      result
    end

    def step(time_lapse)
      return false if @space.nil?
      return false if time_lapse == 0
      # Everything leads to position changes
      # From acceleration to velocity, from velocity to displacement
      @space.items[:objects].each do |name, obj|
        total_acceleration = get_linear_acceleration(obj)
        total_velocity     = get_linear_velocty(obj)
        total_velocity     = total_velocity.add(
          velocity(total_acceleration, time_lapse, total_velocity)
          )
        total_displacement = CVector.new(0, 0, 0)
        total_displacement.x = total_velocity.x * time_lapse
        total_displacement.y = total_velocity.y * time_lapse
        total_displacement.z = total_velocity.z * time_lapse
        obj.linear_velocity.vector = total_velocity
        obj.position = obj.position.add(total_displacement)
      end
    end
  end
end

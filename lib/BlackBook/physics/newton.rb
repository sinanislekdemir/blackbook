################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'BlackBook/b3dobject'
require 'BlackBook/functions'
require 'BlackBook/physics/physics'

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
      (a * t) + vi
    end

    # position = initial position + (initial vel. * time) + (a * t^2) / 2
    def position_acceleration(a, t, vi = 0, ri)
      ri + (vi * t) + (a * (t**2) / 2)
    end

    # position = initial position + vel * init. vel / 2 * time
    def position(v, t, vi, ri)
      ri + (((v + vi) / 2) * t)
    end

    def timeless_velocity(a, r, ri, vi)
      Math.sqrt((vi**2) + (2 * a * (r - ri)))
    end

    def circular_velocity(a, t, wi = 0)
      wi + (a * t)
    end

    def angular_displacement(theta, a, t, wi = 0)
      theta + (wi * time) + (0.5 * a * (t**2))
    end

    def angular_displacement_2(theta, wi, w, time)
      theta + (0.5 * (wi + w) * t)
    end

    def kinetic_energy(m, v)
      0.5 * m * (v**2)
    end

    def potential_energy(m, g, h)
      m * g * h
    end

    def gravity(m1, m2, dist)
      G * (m1 * m2 / (dist**2))
    end

    # Get appied linear acceleration on object
    def get_linear_acceleration(obj)
      result = CVector.new(0, 0, 0)
      @variables.each do |variable|
        if variable.is_a? CAcceleration &&
          variable.direction == CAcceleration::ANGULAR
          result.x += variable.vector.x
          result.y += variable.vector.y
          result.z += variable.vector.z
        end
      end
      result.x += obj.linear_acceleration.x
      result.y += obj.linear_acceleration.y
      result.z += obj.linear_acceleration.z
      result
    end

    # Get applied linear veloctiy on object
    def get_linear_velocty(obj)
      result = CVector.new(0, 0, 0)
      @variables.each do |variable|
        if variable.is_a? CVelocity && variable.direction == CVelocity::ANGULAR
          result.x += variable.vector.x
          result.y += variable.vector.y
          result.z += variable.vector.z
        end
      end
      result.x += obj.linear_acceleration.x
      result.y += obj.linear_acceleration.y
      result.z += obj.linear_acceleration.z
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
        obj.position.add(total_displacement)
      end
    end
  end
end

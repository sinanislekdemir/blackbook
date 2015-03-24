################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'BlackBook/space_object'
require 'BlackBook/functions'
require 'BlackBook/physics/physics'

module BlackBook
  module Physics
    module Newton
      # Gravitational Constant
      G = 6.67e-11
      MASS_EARTH = 5.97219e24
      RADIUS_EARTH = 6378100

      def self.included(receiver)
        receiver.extend ClassMethods
        receiver.send :include, InstanceMethods
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

      # Newtonian physics
      class Newton < BlackBook::Physics::BlackBookPhysics
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
            obj = SpaceObject.new
            obj.load item
            @items[item['name']] = obj
          end
          data['constants'].each do |constant|
            load_constant constant
          end
        end
      end
    end
  end
end

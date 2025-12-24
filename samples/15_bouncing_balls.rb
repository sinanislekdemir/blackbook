#!/usr/bin/env ruby
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
#
# Bouncing Balls Sample - Demonstrating physics and colors
################################################################

# Add library path to rubtime
$LOAD_PATH << '../lib/'

require 'json'

# Local Libs
require 'blackbook'
require 'ui'
require 'plugins'

# Main application
module BlackBook
  # Ball class with physics
  class Ball
    attr_accessor :object, :velocity, :position, :color, :radius
    
    def initialize(object, x, y, z, color, radius = 0.5)
      @object = object
      @position = CVector.new(x, y, z)
      @velocity = CVector.new(
        rand(-5.0..5.0),
        rand(-5.0..5.0),
        rand(3.0..8.0)
      )
      @color = color
      @radius = radius
      @object.matrix.pos = @position
      @object.material.color.set(color.x, color.y, color.z, 1.0)
    end
    
    def update(delta_time, bounds)
      # Apply gravity
      gravity = -15.0
      @velocity.z += gravity * delta_time
      
      # Update position
      @position.x += @velocity.x * delta_time
      @position.y += @velocity.y * delta_time
      @position.z += @velocity.z * delta_time
      
      # Bounce off walls (X axis)
      if @position.x - @radius < -bounds || @position.x + @radius > bounds
        @velocity.x *= -0.9  # Damping
        @position.x = @position.x < 0 ? -bounds + @radius : bounds - @radius
      end
      
      # Bounce off walls (Y axis)
      if @position.y - @radius < -bounds || @position.y + @radius > bounds
        @velocity.y *= -0.9  # Damping
        @position.y = @position.y < 0 ? -bounds + @radius : bounds - @radius
      end
      
      # Bounce off floor
      if @position.z - @radius < 0
        @position.z = @radius
        @velocity.z *= -0.85  # Damping (less bouncy)
        
        # Friction on horizontal movement
        @velocity.x *= 0.95
        @velocity.y *= 0.95
      end
      
      # Update object position
      @object.matrix.pos = @position
    end
    
    def check_collision(other)
      # Calculate distance between centers
      dx = @position.x - other.position.x
      dy = @position.y - other.position.y
      dz = @position.z - other.position.z
      distance = Math.sqrt(dx * dx + dy * dy + dz * dz)
      
      # Check if spheres are colliding
      min_distance = @radius + other.radius
      return nil if distance >= min_distance || distance < 0.001
      
      # Return collision info
      {
        distance: distance,
        min_distance: min_distance,
        dx: dx,
        dy: dy,
        dz: dz
      }
    end
    
    def resolve_collision(other, collision_info)
      distance = collision_info[:distance]
      dx = collision_info[:dx]
      dy = collision_info[:dy]
      dz = collision_info[:dz]
      min_distance = collision_info[:min_distance]
      
      # Normalize the collision vector
      nx = dx / distance
      ny = dy / distance
      nz = dz / distance
      
      # Separate the spheres completely
      overlap = min_distance - distance
      @position.x += nx * overlap * 0.5
      @position.y += ny * overlap * 0.5
      @position.z += nz * overlap * 0.5
      
      other.position.x -= nx * overlap * 0.5
      other.position.y -= ny * overlap * 0.5
      other.position.z -= nz * overlap * 0.5
      
      # Calculate relative velocity
      rel_vel_x = @velocity.x - other.velocity.x
      rel_vel_y = @velocity.y - other.velocity.y
      rel_vel_z = @velocity.z - other.velocity.z
      
      # Calculate velocity along collision normal
      vel_along_normal = rel_vel_x * nx + rel_vel_y * ny + rel_vel_z * nz
      
      # Don't resolve if spheres are moving apart
      return if vel_along_normal > 0
      
      # Calculate restitution (bounciness)
      restitution = 0.85
      
      # Calculate impulse scalar (equal mass assumption)
      impulse = -(1 + restitution) * vel_along_normal * 0.5
      
      # Apply impulse to both balls
      @velocity.x += impulse * nx
      @velocity.y += impulse * ny
      @velocity.z += impulse * nz
      
      other.velocity.x -= impulse * nx
      other.velocity.y -= impulse * ny
      other.velocity.z -= impulse * nz
      
      # Update positions immediately
      @object.matrix.pos = @position
      other.object.matrix.pos = other.position
    end
  end

  # Application object
  class Main < BlackBook::Engine
    attr_accessor :space
    attr_writer :space

    def initialize(w, h, title)
      # First initialize BlackBook Engine
      super
      # Enable GRID for the scene
      BlackBook::Registry.instance.write('grid', true)
      BlackBook::Registry.instance.write('grid_count', 20)
      BlackBook::Registry.instance.write('grid_size', 1)
      
      # Create 3D space with viewport settings
      @space = Space.new(
        @viewport_x,
        @viewport_y
      )
      
      # Setup camera
      eye = CVector.new(20.0, 20.0, 15.0)
      up  = CVector.new(0.0, 0.0, 1.0)
      target = CVector.new(0.0, 0.0, 3.0)
      @space.add_camera(
        eye_position: eye,
        up: up,
        target_position: target
      )
      
      # Add lights
      light = @space.create_light
      light.position.set(10.0, 10.0, 15.0)
      
      light_2 = @space.create_light
      light_2.position.set(-10.0, -10.0, 15.0)
      
      # Create colorful balls
      @balls = []
      @bounds = 10.0
      
      colors = [
        CVector.new(1.0, 0.2, 0.2),  # Red
        CVector.new(0.2, 1.0, 0.2),  # Green
        CVector.new(0.2, 0.2, 1.0),  # Blue
        CVector.new(1.0, 1.0, 0.2),  # Yellow
        CVector.new(1.0, 0.2, 1.0),  # Magenta
        CVector.new(0.2, 1.0, 1.0),  # Cyan
        CVector.new(1.0, 0.6, 0.2),  # Orange
        CVector.new(0.6, 0.2, 1.0),  # Purple
      ]
      
      # Create 8 balls with different colors
      colors.each_with_index do |color, i|
        obj = @space.add_object(
          filename: '../data/sphere.raw',
          name: "ball_#{i}"
        )
        
        # Random starting position
        x = rand(-@bounds + 1..@bounds - 1)
        y = rand(-@bounds + 1..@bounds - 1)
        z = rand(3.0..10.0)
        
        # Use calculated radius from the object
        radius = obj.radius > 0 ? obj.radius : 0.5
        ball = Ball.new(obj, x, y, z, color, radius)
        @balls << ball
      end
      
      # Add ground plane
      ground = @space.add_object(
        filename: '../data/ground.raw',
        name: 'ground'
      )
      ground.matrix.pos.z = -0.1
      ground.material.color.set(0.3, 0.3, 0.3, 1.0)
      
      @last_time = Time.now
    end

    def mouse_move(x, y, right, left, middle)
      super
      @space.mouse_move(
        x * (@viewport_x / @window_width),
        y * (@viewport_y / @window_height),
        right,
        left,
        middle)
    end

    def render
      super
      # Initialize space if gl is not active
      @space.init_gl unless @space.gl_active
      
      # Calculate delta time
      current_time = Time.now
      delta_time = current_time - @last_time
      @last_time = current_time
      
      # Update all ball positions first
      @balls.each do |ball|
        ball.update(delta_time, @bounds)
      end
      
      # Resolve collisions multiple times for stability
      3.times do
        @balls.each_with_index do |ball, i|
          @balls[(i+1)..-1].each do |other|
            collision = ball.check_collision(other)
            ball.resolve_collision(other, collision) if collision
          end
        end
      end
      
      @space.render
    end
  end
end

BlackBook::Main.new(
  800,
  600,
  'BlackBook - Bouncing Balls'
).engine_loop

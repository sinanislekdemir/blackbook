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

require 'BlackBook/b3dobject'
require 'BlackBook/functions'
require 'BlackBook/constants'
require 'BlackBook/registry'

module BlackBook
  # Collision detection class
  class Collision
    attr_accessor :hit_point, :hit_normal, :result, :penetration
    attr_writer :hit_point, :hit_normal, :result, :penetration

    # Test object collision
    def test(source, target)
      # Spherical collision check for faster control.
      algorithm = BlackBook::Registry.instance.read('collision_algorithm')
      algorithm = 'SPHERICAL' if algorithm.nil?
      case algorithm
      when 'SPHERICAL'
        return spherical(source, target)
      when 'AABB'
        return aabb(source, target)
      end
    end

    # Bounding sphere, collision detection
    def spherical(source, target)
      d = source.matrix.pos.distance(target.matrix.pos)
      r = target.radius + source.radius
      hit = r > d
      @result = hit
      hit
    end

    # Axis Aligned Bounding Box
    def aabb(source, target)
      return false unless spherical(source, target)
      min_source = source.local_to_absolute(source.min)
      max_source = source.local_to_absolute(source.max)
      min_target = target.local_to_absolute(target.min)
      max_target = target.local_to_absolute(target.max)
      center_source = max_source.sub(min_source)
      center_target = max_target.sub(min_target)
      center_source.div(2.0)
      center_target.div(2.0)
      center_source = source.local_to_absolute(center_source)
      center_target = target.local_to_absolute(center_target)
      dist_x = (center_target.x - center_source.x).abs
      dist_y = (center_target.y - center_source.y).abs
      dist_z = (center_target.z - center_source.z).abs

      x_a = (max_source.x - min_source.x) / 2.0
      y_a = (max_source.y - min_source.y) / 2.0
      z_a = (max_source.z - min_source.z) / 2.0

      x_b = (max_target.x - min_target.x) / 2.0
      y_b = (max_target.y - min_target.y) / 2.0
      z_b = (max_target.z - min_target.z) / 2.0
      c_x = dist_x - (x_a + x_b) <= 0
      c_y = dist_y - (y_a + y_b) <= 0
      c_z = dist_z - (z_a + z_b) <= 0
      return c_x && c_y && c_z
    end
  end
end

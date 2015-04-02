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

module BlackBook
  # Collision detection class
  class Collision
    attr_accessor :hit_point, :hit_normal, :result
    attr_writer :hit_point, :hit_normal, :result
    def test(source, target)
      v1 = CVector.new(0, 0, 0)
      v2 = v1.clone
      v3 = v1.clone
      p1 = v1.clone
      p2 = v1.clone
      p3 = v1.clone
      source.faces.each do |source_face|
        v1.set(source_face[0], source_face[1], source_face[2])
        v2.set(source_face[3], source_face[4], source_face[5])
        v3.set(source_face[6], source_face[7], source_face[8])
        target.faces.each do |target_face|
          p1.set(target_face[0], target_face[1], target_face[2])
          p2.set(target_face[3], target_face[4], target_face[5])
          p3.set(target_face[6], target_face[7], target_face[8])
          # Part 1
          rti = BlackBook.raycast_triangle_intersect(
            v1, v2.sub(v1).normalize, p1, p2, p3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
          rti = BlackBook.raycast_triangle_intersect(
            v2, v3.sub(v2).normalize, p1, p2, p3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
          rti = BlackBook.raycast_triangle_intersect(
            v3, v1.sub(v3).normalize, p1, p2, p3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
          # Part 2
          rti = BlackBook.raycast_triangle_intersect(
            p1, p2.sub(p1).normalize, v1, v2, v3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
          rti = BlackBook.raycast_triangle_intersect(
            p2, p3.sub(p2).normalize, v1, v2, v3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
          rti = BlackBook.raycast_triangle_intersect(
            p3, p1.sub(p3).normalize, v1, v2, v3
            )
          if rti[:hit]
            @result = true
            @hit_point = res[:point]
            @hit_normal = res[:normal]
            return true
          end
        end
      end
      @result = false
    end
  end
end

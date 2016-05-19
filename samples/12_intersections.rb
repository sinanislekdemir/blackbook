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

$LOAD_PATH << '../lib/'

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
# Some Vector Math Samples
################################################################

require 'blackbook'

# Vector operations
v1 = BlackBook::CVector.new(0.0, 0.0, 8.0)
v2 = BlackBook::CVector.new(10.0, 0.0, 9.0)
v3 = BlackBook::CVector.new(0.0, 10.0, 10.0)

puts 'Triangle vectors'
puts 'v1 = ' + v1.to_array.to_s
puts 'v2 = ' + v2.to_array.to_s
puts 'v3 = ' + v3.to_array.to_s

ray_start = BlackBook::CVector.new(2.0, 2.0, 20.0)
ray_vector = BlackBook::CVector.new(0, 0, -1.0)

puts 'Ray vectors'
puts 'ray_start  = ' + ray_start.to_array.to_s
puts 'ray_vector = ' + ray_vector.to_array.to_s

puts 'Raycast:'
res = BlackBook.raycast_triangle_intersect(
  ray_start,
  ray_vector,
  v1, v2, v3)

puts 'Hit result: ' + res[:hit].to_s
puts 'Hit point: ' + res[:point].to_array.to_s
puts 'Hit normal: ' + res[:normal].to_array.to_s

puts 'Point on line control'
if BlackBook.point_on_line(res[:point], ray_start,
                           BlackBook::CVector.new(2.0, 2.0, 0))
  puts 'Point hits the line'
else
  puts 'Point misses line'
end

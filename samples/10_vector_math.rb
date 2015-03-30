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
v1 = BlackBook::CVector.new(10.0, 10.0, 11.0)
v2 = BlackBook::CVector.new(-12.0, 7.3, 12.0)
v3 = BlackBook::CVector.new(10.0, 7.3, -12.0)

puts "Vector 1:               " + v1.to_array.to_s
puts "Vector 2:               " + v2.to_array.to_s
puts "Distance:               " + v1.distance(v2).to_s
puts "Cross Product v1 x v2 = " + v1.cross(v2).to_array.to_s
puts "Dot Product v1 * v2 =   " + v1.dot(v2).to_s
sub = v1.sub(v2)
puts "v1 - v2 =               " + sub.to_array.to_s
add = v1.add(v2)
puts "v1 + v2 =               " + add.to_array.to_s
puts "Rotate v1 around z axis 45 degrees"
v1.rotate_around_z 45
puts "v1 =                    " + v1.to_array.to_s
puts "Spherical coordinates of v1"
v1.update_spherical
puts "v1.r =                  " + v1.r.to_s
puts "v1.theta =              " + v1.theta.to_s
puts "v1.phi =                " + v1.phi.to_s
puts "Normalize v1"
v1.normalize
puts "v1 =                    " + v1.to_array.to_s

matrix_1 = [
  1, 0, 0, 0,
  2, 0, 1, 0,
  4, 2, 2, 0,
  10, 3, 3, 1
]

matrix_2 = [
  1, 0, 0, 0,
  2, 0, 1, 0,
  4, 2, 2, 0,
  10, 3, 3, 1
]

puts "Matrix 1:               " + matrix_1.to_s
puts "Matrix 2:               " + matrix_2.to_s
mm = BlackBook.multiply_matrices_4by4(matrix_1, matrix_2)
puts "Multiplication Matrix = " + mm.to_s

puts "Multiply Matrix_1 by Vector 1"
puts "matrix_1 x v1         = " + BlackBook.multiply_matrix_by_vector(
  matrix_1, v1.to_array
  ).to_s
puts ""
puts "Vector 1:               " + v1.to_array.to_s
puts "Vector 2:               " + v2.to_array.to_s
puts "Vector 3:               " + v3.to_array.to_s
puts "Plane Normal"
puts BlackBook.calc_plane_normal(v1, v2, v3).to_array.to_s

puts ""
puts "45 degrees = " + BlackBook.deg_to_rad(45).to_s + ' radians'
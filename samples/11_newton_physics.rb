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

# Create a dummy space
space = BlackBook::Space.new(0, 0)
physics = BlackBook::Newton.new(space)

puts 'Free fall starting'
mass = 100

puts 'Create dummy space object'
object = space.create_object
object.mass = mass
object.position.set(0, 0, 200.0)

puts 'Set gravity'
gravity = -9.80665
physics.add_variable(
  BlackBook::CAcceleration.new(
    BlackBook::CVector.new(0, 0, gravity), 'gravity'
  )
)

initial = Time.now.to_f

loop do
  if physics.global_time.calc_time > 1
    time_step = physics.global_time.step
    puts 'Object position = ' +
      object.position.to_array.to_s +
      ' time diff = ' + time_step.to_s
    physics.step(time_step)
    physics.global_time.reset_time
    break if object.position.z < 0
  end
end

finish = Time.now.to_f

puts 'Hit the ground!'
puts 'Last position = ' + object.position.to_array.to_s
puts 'Total time = ' + (finish - initial).to_s + ' seconds'

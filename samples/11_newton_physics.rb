#!/usr/bin/env ruby

$LOAD_PATH << '../lib/'

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
# Some Vector Math Samples
################################################################

require 'blackbook'

#Create a dummy space
space = BlackBook::Space.new(0, 0)
physics = BlackBook::Newton.new(space)

puts "Free fall starting"
mass = 100

puts "Create dummy space object"
object = space.create_object
object.mass = mass
object.position.set(0, 0, 200.0)

puts "Set gravity"
gravity = -9.80665
physics.add_variable(BlackBook::CAcceleration.new(
  BlackBook::CVector.new(0, 0, gravity), 'gravity'
  ))

initial = Time.now.to_f

while true
  if physics.global_time.calc_time > 1
    time_step = physics.global_time.step
    puts "Object position = " + object.position.to_array.to_s + " time diff = " + time_step.to_s
    physics.step(time_step)
    physics.global_time.reset_time
    break if object.position.z < 0
  end
end

finish = Time.now.to_f

puts "Hit the ground!"
puts "Last position = " + object.position.to_array.to_s
puts "Total time = " + (finish - initial).to_s + ' seconds'
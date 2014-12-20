################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Newtonian Physics Formulas and constants
module BbNewtonModule
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
end

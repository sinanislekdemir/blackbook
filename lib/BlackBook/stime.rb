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

module BlackBook
  # Space - Time Class
  class STime
    attr_accessor :year, :days, :seconds, :scale, :start, :diff,
      :last_time
    attr_writer :year, :days, :seconds, :scale, :start, :diff,
      :last_time

    # start timer
    def initialize
      @start = Time.now.to_f
      @last_time = @start
    end

    # get time difference
    def calc_time
      @diff = Time.now.to_f - @start
    end

    def step
      r = Time.now.to_f - @last_time
      @last_time = Time.now.to_f
      r
    end

    # reset start time
    def reset_time
      @start = Time.now.to_f
    end

    # calculate time dilation caused by velocity
    def time_dilation(velocity)
      calc_time
      f = (velocity.to_f**2) / (299792458.to_f**2)
      @diff / Math.sqrt(1.0 - f)
    end
  end
end

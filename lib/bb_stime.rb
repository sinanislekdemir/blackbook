################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Space - Time Class
class BBSTime
  attr_accessor :year, :days, :seconds, :scale, :start, :diff
  attr_writer :year, :days, :seconds, :scale, :start, :diff

  # start timer
  def initialize
    @start = Time.now.to_f
  end

  # get time difference
  def calc_time
    @diff = Time.now.to_f - @start
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

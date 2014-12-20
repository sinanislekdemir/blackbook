################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'bb_base'
require 'ui/bb_text'

# BB Ui Element Base Class
class BBUiElement < BBBase
  attr_writer :x, :y, :z, :w, :h, :title
  attr_accessor :x, :y, :z, :w, :h, :title

  def initialize(options)
    super
    @x = options[:x] if options.key?(:x)
    @y = options[:y] if options.key?(:y)
    @z = options[:z] if options.key?(:z)
    @w = options[:w] if options.key?(:w)
    @h = options[:h] if options.key?(:h)
    @title = options[:title] if options.key?(:title)
  end
end

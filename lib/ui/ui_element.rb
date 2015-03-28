################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'BlackBook/base'
require 'ui/text'

module UI
  # BB Ui Element Base Class
  class UiElement < BlackBook::Base
    attr_writer :x, :y, :z, :w, :h, :title
    attr_accessor :x, :y, :z, :w, :h, :title

    def initialize(options)
      super
      @x = options[:x] if options.key?(:x)
      @y = options[:y] if options.key?(:y)
      @z = options[:z] if options.key?(:z)
      @w = options[:w] if options.key?(:w)
      @h = options.key?(:h) ? options[:h] : 35
      @title = options[:title] if options.key?(:title)
    end
  end
end
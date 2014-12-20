################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'bb_base'
require 'ui/bb_text'
require 'ui/bb_window'

# Main UI Hud Controller
class BBUi < BBBase
  attr_writer :w, :h, :items, :scale, :depth
  attr_accessor :w, :h, :items, :scale, :depth

  def initialize(w, h, scale = 10)
    super
    @items = {}
    @w, @h, @scale = w, h, scale
    @depth = 0
  end

  #
  # Add a new windows
  # @param options [Hash] Window properties
  #
  # @return [BBWindow] Created Window Object
  def add_window(options)
    w = BBWindow.new(options)
    w.z = @depth * 100
    @items[options[:name]] = w
    @depth += 1
    w
  end

  def render
    GL.PushMatrix
    GL.Disable(GL::LIGHTING)
    GL.MatrixMode(GL::PROJECTION)
    GL.PushMatrix
    GL.LoadIdentity
    GL.Ortho(0.0, @w, @h, 0.0, -1.0, 10.0)
    GL.MatrixMode(GL::MODELVIEW)
    GL.LoadIdentity
    GL.Disable(GL::CULL_FACE)
    GL.Clear(GL::DEPTH_BUFFER_BIT)
    @items.each do |key, item|
      item.render
    end
    GL.MatrixMode(GL::PROJECTION)
    GL.PopMatrix
    GL.MatrixMode(GL::MODELVIEW)
    GL.Enable(GL::LIGHTING)
    GL.PopMatrix
  end

  def mouse_move(x, y, right_b, left_b, middle_b)
    @items.each do |name, obj|
      obj.mouse(x, y, right_b, left_b, middle_b) if obj.respond_to?('mouse')
    end
    false
  end
end

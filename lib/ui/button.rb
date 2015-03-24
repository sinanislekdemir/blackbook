################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'ui/ui_element'
require 'ui/text'
require 'BlackBook/functions'

module UI
  #
  # BB Button Class
  #
  # @attr label [String] Label on button
  # @attr click [Method] OnClick event handler
  # @attr caption [BBText] Caption object over button surface
  # @attr hover [CVector] OnHover Color
  # @attr font_size [Integer] Font Size in Pixels
  # @author [sinan islekdemir]
  #
  class Button < UiElement
    attr_accessor :label, :click, :caption, :hover, :font_size
    attr_writer :label, :click, :caption, :hover, :font_size

    #
    # Initialize BBButton Element
    # @param options [Hash] (x, y, z, w, h, title, font_size)
    #
    # @return [Boolean] Reposition done
    def initialize(options)
      super
      @font_size = options.key?(:font_size) ? options[:font_size] : 30
      @caption = Text.new(x: 0, y: 0, h: @font_size, title: title)
      @click = nil
      @hover = false
      reposition
    end

    #
    # Reposition text on button in case of changing title
    #
    # @return [Boolean] Success
    def reposition
      w = @w
      @w = @caption.width * 30 + 30 if w < @caption.width * 30 + 30
      w = @w
      @caption.d = 2
      @caption.position.z = 2
      @caption.position.x = (w / 2 - (@caption.width * 30) / 2)
      @caption.position.y = @font_size + 5
      true
    end

    #
    # Mouse event handler
    # @param x [Integer] Cursor X Position
    # @param y [Integer] Cursor Y Position
    # @param right_b [Integer] Right Mouse Button
    # @param left_b [Integer] Left Mouse Button
    # @param middle_b [Integer] Middle Mouse Button
    #
    # @return [Boolean] Success
    def mouse(x, y, right_b, left_b, middle_b)
      x -= @x
      y -= @y
      @hover = false
      return false if x < 0 || x > @w || y < 0 || y > @h
      @hover = true
      click.call if left_b == 1
    end

    #
    # General Renderer
    #
    # @return [Boolean] Success
    def render
      color = @hover ? CVector.new(255, 165, 0, 0.8) : CVector.new(0, 0, 0, 0.8)
      options = {
        x: @x, y: @y, z: 1 / (10000 - @z.to_f),
        width: @w, height: @h, color: color,
        border: true, border_color: CVector.new(255, 165, 0, 0.8)
      }
      BlackBook::draw_box_2d(options)
      GL.PushMatrix
      GL.Translatef(@x, @y, 1 / (10000 - @z.to_f))
      @hover ? @caption.color.set(0, 0, 0) : @caption.color.set(1.0, 1.0, 1.0)
      @caption.y = 5
      @caption.render
      GL.PopMatrix
    end
  end
end

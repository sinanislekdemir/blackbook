################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'ui/bb_ui_element'
require 'ui/bb_text'

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
class BBButton < BBUiElement
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
    @caption = BBText.new(x: 0, y: 0, h: @font_size, title: title)
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
      w: @w, h: @h, color: color,
      border: true, border_color: CVector.new(255, 165, 0, 0.8)
    }
    draw_box_2d(options)
    GL.PushMatrix
    GL.Translatef(@x, @y, 1 / (10000 - @z.to_f))
    @hover ? @caption.color.set(0, 0, 0) : @caption.color.set(1.0, 1.0, 1.0)
    @caption.render
    GL.PopMatrix
  end
end

#
# BB Window Class
#
# @attr title_bar [BBText] Title Bar Element
# @attr items [Hash] Items of widgets inside window
# @attr font_size [Integer] Font size in pixels
# @author [sinan]
#
class BBWindow < BBUiElement
  attr_writer :title_bar, :items, :font_size
  attr_accessor :title_bar, :items, :font_size

  #
  # Initialize Window Element
  # @param options [Hash] (x, y, z, w, h, title, font_size)
  #
  # @return [Hash] Empty Items Hash
  def initialize(options)
    super
    @font_size = options.key?(:font_size) ? options[:font_size] : 30
    title = options[:title] if options.key?(:title)
    @title_bar = BBText.new(x: 0, y: 0, w: 0, h: @font_size, title: title)
    @title_bar.d = 2
    @title_bar.position.x = 5
    @title_bar.position.y = @font_size - 5
    @title_bar.color.set(0, 1.0, 0)
    @title_bar.position.z = 2
    @items = {}
  end

  #
  # Create Button
  # @param options [Hash] (x, y, z, w, h, title, font_size, name)
  #
  # @return [type] [description]
  def create_button(options)
    b = BBButton.new(options)
    b.z = 2
    @items[options[:name]] = b
    b
  end

  #
  # [create_label description]
  # @param options [Hash] (x, y, z, w, h, title)
  #
  # @return [BBText] Created label object
  def create_label(options)
    text = BBText.new(options)
    text.h = 30 unless options.key?(:h)
    text.position.x = options[:x]
    text.position.y = options[:y]
    text.d = 2
    @items[options[:name]] = text
    text
  end

  #
  # Mouse event handler
  # @param x [Integer] Cursor X Position
  # @param y [Integer] Cursor Y Position
  # @param right_b [Integer] Right Mouse Button
  # @param left_b [Integer] Left Mouse Button
  # @param middle_b [Integer] Middle Mouse Button
  #
  def mouse(x, y, right_b, left_b, middle_b)
    @items.each do |name, item|
      if item.respond_to?(:mouse)
        item.mouse(x - @x, y - @y, right_b, left_b, middle_b)
      end
    end
  end

  #
  # Render Function
  #
  def render
    options = {
      x: @x, y: @y, z: 1 / (10000 - @z.to_f),
      width: @w, height: @h, color: CVector.new(1.0, 1.0, 1.0),
      border: true, border_color: CVector.new(218, 112, 214),
      border_size: 3
    }
    draw_box_2d(options)
    GL.PushMatrix
    GL.Translatef(@x, @y, 1 / (10000 - @z.to_f))
    @title_bar.render
    @items.each do |name, item|
      item.render
    end
    GL.PopMatrix
  end
end

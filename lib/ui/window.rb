################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'BlackBook/functions'
require 'ui/ui_element'
require 'ui/text'
require 'ui/button.rb'
require 'ui/edit.rb'

module UI
  #
  # BB Window Class
  #
  # @attr title_bar [BBText] Title Bar Element
  # @attr items [Hash] Items of widgets inside window
  # @attr font_size [Integer] Font size in pixels
  # @author [sinan]
  #
  class Window < UiElement
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
      @title_bar = Text.new(x: 0, y: 0, w: 0, h: @font_size, title: title)
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
      b = Button.new(options)
      b.z = 2
      @items[options[:name]] = b
      b
    end

    #
    # Create Edit
    # @param options [Hash] (x, y, z, w, h, value, font_size, name)
    #
    # @return [type] [description]
    def create_edit(options)
      e = Edit.new(options)
      e.z = 2
      @items[options[:name]] = e
      e
    end

    #
    # [create_label description]
    # @param options [Hash] (x, y, z, w, h, title)
    #
    # @return [BBText] Created label object
    def create_label(options)
      text = Text.new(options)
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
        width: @w, height: @h,
        color: BlackBook::CVector.new(1.0, 1.0, 1.0, 0.8),
        border: true, border_color: BlackBook::CVector.new(218, 112, 214),
        border_size: 3
      }
      BlackBook.draw_box_2d(options)
      GL.PushMatrix
      GL.Translatef(@x, @y, 1 / (10000 - @z.to_f))
      @title_bar.render
      @items.each do |name, item|
        item.render
      end
      GL.PopMatrix
    end
  end
end

################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# simulator starter
require 'glfw3'
require 'opengl'

require 'BlackBook/base'
require 'ui/ui'

module BlackBook
  #
  # BlackBook Engine Class.
  # Creates and handles OpenGL Window - GLF3
  #
  # @author [sinan islekdemir]
  #
  # @attr window_width [Integer] Window Width
  # @attr window_height [Integer] Window Height
  # @attr title [String] Window Title
  # @attr w_m [Integer] Window - Viewport Width Multiplier
  # @attr h_m [Integer] Window - Viewport Height Multiplier
  # @attr left [Integer] Left Mouse Button
  # @attr right [Integer] Right Mouse Button
  # @attr middle [Integer] Middle Mouse Button
  # @attr main_window [Glfw::Window] Main GLFW Window
  # @attr spaces [Array] Array Of BBSpace
  #
  class Engine < Base
    attr_accessor :window_width, :window_height, :title, :w_m, :h_m,
                  :left, :right, :middle, :main_window, :spaces
    attr_writer :window_width, :window_height, :title, :w_m, :h_m,
                :left, :right, :middle, :main_window, :spaces

    #
    # Initialize BBEngine
    # @param w [Integer] [description]
    # @param h [Integer] [description]
    # @param title [String] [description]
    # @param w_m = 1 [Integer] Window - Viewport Multiplier for Width
    # @param h_m = 1 [Integer] Window - Viewport Multiplier for Height
    #
    # @return [Boolean] Success
    def initialize(w, h, title, w_m = 1, h_m = 1)
      super
      Glfw.init
      @window_width = w
      @window_height = h
      @title = title
      @h_m = h_m
      @w_m = w_m
      @left = 0
      @right = 0
      @middle = 0
      @spaces = []
      true
    end

    #
    # Start Engine and Create the main window
    #
    # @return [Boolean]
    def engine_start
      @main_window = Glfw::Window.new(@window_width, @window_height, @title)
      fail 'Unable to create window' if @main_window.nil?
      @main_window.close_callback = -> (window) { window.should_close = true }
      @main_window.mouse_button_callback = lambda {
        |_window, right, left, middle|
        @right, @left, @middle = right, left, middle
      }
      @main_window.char_callback = -> (window, char) do
        puts char.chr
      end
      engine_loop
      true
    end

    #
    # Render Meta Func.
    #
    # @return nil
    def render
    end

    #
    # Engine Main Loop
    #
    # @return [Boolean] Success
    def engine_loop
      @main_window.make_context_current
      until @main_window.should_close?
        Glfw.wait_events
        GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
        render
        @main_window.swap_buffers
      end
      engine_end
    end

    #
    # Engine End - Window destroyer
    #
    # @return [Boolean] Success
    def engine_end
      @main_window.destroy
      Glfw.terminate
    end
  end
end

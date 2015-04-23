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
    attr_accessor :window_width, :window_height, :title,
                  :left, :right, :middle, :main_window, :spaces,
                  :viewport_x, :viewport_y
    attr_writer :window_width, :window_height, :title,
                :left, :right, :middle, :main_window, :spaces,
                :viewport_x, :viewport_y

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
      @left = 0
      @right = 0
      @middle = 0
      @spaces = []
      engine_start
      true
    end

    #
    # Start Engine and Create the main window
    #
    # @return [Boolean]
    def engine_start
      Glfw::Window.window_hint(Glfw::SAMPLES, 4)
      @main_window = Glfw::Window.new(@window_width, @window_height, @title)
      @viewport_x = @main_window.framebuffer_size[0]
      @viewport_y = @main_window.framebuffer_size[1]
      fail 'Unable to create window' if @main_window.nil?
      @main_window.close_callback = -> (window) { window.should_close = true }
      @main_window.mouse_button_callback = lambda { |_window, r, l, m|
        @right, @left, @middle = r, l, m
      }
      @main_window.char_callback = -> (window, char) do
        keypress(char.chr)
      end
      true
    end

    def keypress(chr)
    end

    #
    # Render Meta Func.
    #
    # @return nil
    def render
    end

    # Mouse move meta func
    # @return [nil]
    def mouse_move(x, y, right, left, middle)
    end

    #
    # Engine Main Loop
    #
    # @return [Boolean] Success
    def engine_loop
      @main_window.make_context_current
      until @main_window.should_close?
        mouse_move(
          @main_window.cursor_pos[0],
          @main_window.cursor_pos[1],
          @right,
          @left,
          @middle)
        GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
        render
        @main_window.swap_buffers
        Glfw.poll_events
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

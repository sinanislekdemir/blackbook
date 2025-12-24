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
require 'glfw'
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
                  :viewport_x, :viewport_y, :fullscreen

    #
    # Initialize BBEngine
    # @param w [Integer] [description]
    # @param h [Integer] [description]
    # @param title [String] [description]
    # @param w_m = 1 [Integer] Window - Viewport Multiplier for Width
    # @param h_m = 1 [Integer] Window - Viewport Multiplier for Height
    # @param fs = false [Boolean] fullscreen
    #
    # @return [Boolean] Success
    def initialize(width, height, title, w_m = 1, h_m = 1, fs = false)
      raise "#{title} must be String" unless title.is_a? String
      [width, height, w_m, h_m].map do |x|
        raise "#{x} must be Integer" unless x.is_a? Integer
      end
      super
      GLFW.init
      @window_width  = width
      @window_height = height
      @title  = title
      @left   = 0
      @right  = 0
      @middle = 0
      @spaces = []
      @fullscreen = (fs==true ? GLFW::Monitor.primary : nil)
      engine_start
      return true
    end

    #
    # Start Engine and Create the main window
    #
    # @return [Boolean]
    def engine_start
      GLFW::Window.hint(GLFW::HINT_SAMPLES, 4)
      @main_window = if @fullscreen
                       GLFW::Window.new(@window_width, @window_height, @title, @fullscreen)
                     else
                       GLFW::Window.new(@window_width, @window_height, @title)
                     end
      @viewport_x = @main_window.framebuffer_size.width
      @viewport_y = @main_window.framebuffer_size.height
      raise 'Unable to create window' if @main_window.nil?
      @main_window.on_close do
        @main_window.close
      end
      @main_window.on_mouse_button do |button, action, mods|
        @right = button
        @left = action
        @middle = mods
      end
      @main_window.on_char do |char|
        keypress(char.chr)
      end
      @main_window.on_framebuffer_resize do |width, height|
        @viewport_x = width
        @viewport_y = height
        GL.Viewport(0, 0, width, height)
        on_resize(width, height)
      end
      return true
    end

    def on_resize(width, height)
      # If subclass has @space, resize it
      @space.resize(width, height) if defined?(@space) && @space
      # Also resize all spaces in @spaces array
      @spaces.each { |space| space.resize(width, height) } if @spaces
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
      @main_window.make_current
      until @main_window.closing?
        pos = @main_window.cursor_pos
        mouse_move(
          pos.x,
          pos.y,
          @right,
          @left,
          @middle)
        GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
        render
        @main_window.swap_buffers
        GLFW.poll_events
      end
      engine_end
    end

    #
    # Engine End - Window destroyer
    #
    # @return [Boolean] Success
    def engine_end
      @main_window.destroy
      GLFW.terminate
    end
  end
end

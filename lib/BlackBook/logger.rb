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

require 'pp'
require 'singleton'

module BlackBook
  # Application-wide logging class
  class Logger
    include Singleton
    attr_accessor :filename, :stdout, :file

    def initialize
    end

    def define(args)
      @file = nil # There has to be only one file instance
      if args.key?(:filename)
        @filename = args[:filename]
        @file = File.open(@filename, 'a')
      end
      @stdout = args.key?(:stdout) && args[:stdout]
    end

    def warning(message)
      @file.printf(
        "%-27s - %-10s : %s \n",
        Time.now.to_s,
        'WARNING',
        message
      ) unless @file.nil?
      printf "%-10s : %s\n", 'WARNING', message if @stdout
    end

    def error(message)
      @file.printf(
        "%-27s - %-10s : %s \n",
        Time.now.to_s,
        'ERROR',
        message
      ) unless @file.nil?
      printf "%-10s : %s\n", 'ERROR', message if @stdout
    end

    def info(message)
      @file.printf(
        "%-27s - %-10s : %s \n",
        Time.now.to_s,
        'INFORM',
        message
      ) unless @file.nil?
      printf "%-10s : %s\n", 'INFORM', message if @stdout
    end

    def dump(data)
      @file.printf "%-27s - %-10s : \n", Time.now.to_s, 'DATA:'
      PP.pp(data, @file)
      @file.printf "\n"
      printf "%-10s : \n", 'DATA:'
      PP.pp(data)
      printf "\n"
    end
  end
end

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

require 'BlackBook/engine'
require 'BlackBook/base'
require 'BlackBook/b3dobject'
require 'BlackBook/camera'
require 'BlackBook/constants'
require 'BlackBook/functions'
require 'BlackBook/light'
require 'BlackBook/logger'
require 'BlackBook/space'
require 'BlackBook/stime'
require 'BlackBook/material'

# BlackBook main module definition
module BlackBook
  extend self
  VERSION = '0.0.1'.freeze
end

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

require 'BlackBook/logger'
require 'BlackBook/registry'

$FOLDER = []
def dir_make(name)
 begin
  if not File.directory?(name)
     Dir.mkdir(name)
     return 1, name # create ok
  else
	 return 2, name #already exists
  end
   rescue Exception=>e
	 return 0, name
  ensure
   end
end

def dir_del(dirPath)
  begin
 if File.directory?(dirPath)
   Dir.foreach(dirPath) do |subFile|
     if subFile != '.' and subFile != '..'
       dir_del(File.join(dirPath, subFile))
     end
   end
     Dir.rmdir(dirPath)
  else
     File.delete(dirPath)
  end
 rescue Exception=>e
    #puts "dir_name err: #{e}"
    return 0
 ensure

  end
  return 1
end

def folder_gen() # year-mon-day-min-sec-nsec
  t = Time.now
  tmp = ENV["temp"]
  ss = t.year.to_s+"-"+t.month.to_s+"-"+t.day.to_s+"-"+t.hour.to_s+"-"+
       t.min.to_s+"-"+t.sec.to_s+"-"+t.nsec.to_s
	return tmp+"/"+ss
end

def clear_temp()
  $FOLDER.each do |f|
     #puts "del folder #{f}"
     dir_del(f)
  end
end

module BlackBook
  # BlackBook Base Class
  class Base
    attr_accessor :logger, :registry

    def initialize(*_args)
      logging_params = { filename: 'debug.log', stdout: true }
      Logger.instance.define logging_params
      @registry = Registry.instance
    end
  end
end

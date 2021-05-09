##############################################################################
#    BlackBook 3D Engine
#    Copyright (C) 2015, 2021  Sinan ISLEKDEMIR / DarkSpy
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
# anim.rb: DarkSpy
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'BlackBook/base'
require 'BlackBook/constants'
require 'BlackBook/stime'
require 'BlackBook/b3dobject'
require 'pp'
require 'zipfile'


module BlackBook
    class Anim < B3DObject
        attr_accessor :num_frames, :_loop, :_time, :fps, :_frame, :_path
        attr_accessor :_from_frame, :_to_frame, :_active_framecount, :_frame_period, :animate, :animations, :frames
        attr_accessor :texture_name

        def initialize(fps=30)
              @frames = []
              @_frame = 0
              @num_frames = 0
              @_time = 0
              @_path = ""
              @_loop = false
              @_from_frame = 0
              @_to_frame = 0
              @_active_framecount = 0
              @fps = fps
              @_frame_period = 1.0 / fps
              @animate = true
              @animations = {} #: Dict[str, Tuple[int, int]] = {}
              @objects = []
              @texture_name=''
        end

        def start()
            @animate = true
        end
        def pause()
            @animate = false
        end
        def stop()
            @animate = false
            @_time = 0.0
        end

        def set_range(from_frame, to_frame)
            if from_frame >= @num_frames
                return "Frame range error - from_frame out of bounds"
            end
            if to_frame >= @num_frames
                return "Frame range error - to_frame out of bounds"
            end
            if from_frame < 0 or to_frame < 0
                return "Frame range error - Negative value defined"
            end
            @_from_frame = from_frame
            @_to_frame = to_frame
            @_active_framecount = to_frame - from_frame
            @_frame_period = 1.0 / @fps
        end

        def set_animation(name, from_frame, to_frame)
            @animations[name] = [from_frame, to_frame]
        end

        def run_animation(name)
            if not @animations.has_key?(name)
                return "Animation not defined"
            end
            self.set_range(@animations[name][0], @animations[name][1])
        end

        def load_texture(texture) #added
            @texture_name = texture # for lazy load. just save it
        end

        def load_file(filename)
            if not FileTest::exist?(filename)
                return "File not found: {filename}"
            end
            @_path = File.dirname(filename)
            archive = ZipFile.new(filename)
            files = archive.namelist()

            a=0
            n=[]
            loop {
                f = files[a]; a += 1; n<<f.to_s.split('.')[0].to_i;
                break if a>=files.length
              }
            max_frame, min_frame = n.max, n.min
            f = min_frame
            ret, dname = dir_make(folder_gen())
            puts "dirmake #{ret}, #{dname}"
            if ret == 0
              return "temp folder makes fail"
            else
              $FOLDER << dname
            end
            while f < max_frame
                #progress(f, max_frame - 1)
                #wobj = B3DObject.new()
                #wobj.path = @_path
                #data = archive.read("#{f.to_s}.obj")
                #material = archive.read("#{f.to_s}.mtl")

                #wobj.material.load_texture(material)
                #wobj.load_obj_from_mem(data)
                objs = archive.write(dname, "#{f.to_s}.obj")
                archive.write(dname, "#{f.to_s}.mtl")
                #puts "objs #{objs}"
                @frames << objs
                f += 1
              end
            @_active_framecount = max_frame - min_frame
            @num_frames = max_frame - min_frame
            #archive.close()
        end
      end
=begin
        def render(self, lit: bool, shader: Shader, parent_matrix: Optional[np.ndarray] = None, _primitive: int = None):
            if not self._visible:
                return
            self.update_matrix(parent_matrix=parent_matrix)
            self.track()

            if not self.animate:
                self.frames[0].render(lit, shader, self._model_matrix)
                return

            if self._time == 0:
                self._time = time.time()

            if time.time() - self._time >= self._frame_period:
                self._frame = (self._frame + 1) % self._active_framecount
                self._time = time.time()
            render_frame = self._frame + self._from_frame
            self.frames[render_frame].render(lit, shader, self._model_matrix)
        end

        def toggle_wireframe(self) -> None:
            d = (self.material.display + 1) % 3

            for mat in self.materials.values():
                mat.display = d
                mat.particle_size = 0.01

            if d == POINTS:
                self.shader = PARTICLE_SHADER
                self.refresh()
            else:
                self.shader = DEFAULT_SHADER
                self.refresh()

            for frame in self.frames:
                frame.toggle_wireframe()
        end
=end
end

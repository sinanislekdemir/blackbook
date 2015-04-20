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

require 'opengl'
require 'BlackBook/base'
require 'BlackBook/constants'
require 'BlackBook/stime'
require 'pp'

module BlackBook
  #
  # 3D Object - Base Class
  #
  # @author [sinan islekdemir]
  #
  # @attr faces [Array] holds the array of faces inside the object
  # @attr mass [Float] total mass of the object
  # @attr roll [Float] Roll angle in degrees
  # @attr pitch [Float] Pitch angle in degrees
  # @attr yaw [Float] Yaw angle in degrees
  # @attr position [CVector] Position vector of the object
  # @attr time [Float] Time frame of the object
  # @attr name [String] Name of the object
  # @attr scale [CVector] Scale of the object for rendering
  # @attr index [Integer] GlGenList OpenGL List Index
  # @attr min [CVector] Minimum coordinates
  # @attr max [CVector] Maximum coordinates
  #
  class B3DObject < Base
    attr_writer :faces, :mass, :roll, :pitch, :yaw,
                :time, :name, :scale, :index,
                :min, :max, :data_size, :normal_index,
                :kinetic_energy, :potential, :type, :angular_velocity,
                :angular_acceleration, :linear_velocity, :linear_acceleration,
                :material, :matrix, :radius
    attr_accessor :faces, :mass, :roll, :pitch, :yaw,
                  :time, :name, :scale, :index,
                  :min, :max, :data_size, :normal_index,
                  :kinetic_energy, :potential, :type, :angular_velocity,
                  :angular_acceleration, :linear_velocity, :linear_acceleration,
                  :material, :matrix, :radius

    PARTICLE = 0
    SOLID_CUBE = 1
    SOLID_SPHERE = 2
    SOLID_MESH = 3
    SOFT_CUBE = 4
    SOFT_SPHERE = 5
    SOFT_MESH = 6

    #
    # Initialize basic variables with default.
    #
    # @return [BB3DObject] return self
    def initialize
      @vertices = []
      @indices = []
      @texcoords = []
      @mass, @roll, @pitch, @yaw = 0.0, 0.0, 0.0, 0.0
      @position     = CVector.new(0, 0, 0, 1)
      @scale        = CVector.new(1, 1, 1, 1)
      @min, @max, @index = nil, nil, -1
      @time         = STime.new
      @vertex_data  = []
      @data_size    = 0
      # Physics Related
      @kinetic_energy = 0.0
      @potential    = 0.0
      @type         = PARTICLE
      @matrix       = CMatrix.new
      @radius       = 0.0
      @min          = CVector.new(9999999, 9999999, 9999999)
      @max          = CVector.new(-9999999, -9999999, -9999999)
      @angular_velocity     = CVelocity.new(
        CVector.new(0, 0, 0, 1),
        '',
        0,
        0,
        CVelocity::ANGULAR
        )
      @angular_acceleration = CAcceleration.new(
        CVector.new(0, 0, 0, 1),
        '',
        0,
        0,
        CAcceleration::ANGULAR
        )
      @linear_acceleration  = CAcceleration.new(CVector.new(0, 0, 0, 1))
      @linear_velocity      = CVelocity.new(CVector.new(0, 0, 0, 1))
      @material = Material.new
    end

    # Convert local vector to absolute coordinates
    # @param [CVector] Vector
    # @param [CMatrix] Absolute Matrix
    # @return [CVector] Absolute Vector
    def local_to_absolute(v)
      # @matrix[3][0] = @position.x
      # @matrix[3][1] = @position.y
      # @matrix[3][2] = @position.z
      # v = BlackBook.vector_transform(v, @matrix)
      # v
    end

    # rotate object
    # @param [Float] x axis
    # @param [Float] y axis
    # @param [Float] z axis
    def rotate(x, y, z)
      @matrix.rotate x, y, z
    end

    #
    # Load Mass Data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Float] Mass
    def load_mass(data)
      @mass = data['mass'] if data.key?('mass')
    end

    #
    # Load position data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [CVector] Position vector
    def load_position(data)
      @matrix.pos.x = data['position'][0] if data.key?('position')
      @matrix.pos.y = data['position'][1] if data.key?('position')
      @matrix.pos.z = data['position'][2] if data.key?('position')
    end

    #
    # Load Rotation Data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Float] Returns Yaw Flaot
    def load_rotation(data)
      @roll   = data['roll'] if data.key?('roll')
      @pitch  = data['pitch'] if data.key?('pitch')
      @yaw    = data['yaw'] if data.key?('yaw')
    end

    #
    # Load Time Data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Float] Returns Time
    def load_time(data)
      @time = data['time'] if data.key?('time')
    end

    def load_type(data)
      @type = data['type'] if data.key?('type')
    end

    def load_linear_velocity(data)
      return unless data.key?('linear_velocity')
      @linear_velocity.vector.x = data['linear_velocity'][0]
      @linear_velocity.vector.y = data['linear_velocity'][1]
      @linear_velocity.vector.z = data['linear_velocity'][2]
    end

    def load_linear_acceleration(data)
      return unless data.key?('linear_acceleration')
      @linear_acceleration.vector.x = data['linear_acceleration'][0]
      @linear_acceleration.vector.y = data['linear_acceleration'][1]
      @linear_acceleration.vector.z = data['linear_acceleration'][2]
    end

    def load_angular_velocity(data)
      return unless data.key?('angular_velocity')
      @angular_velocity.vector.x = data['angular_velocity'][0]
      @angular_velocity.vector.y = data['angular_velocity'][1]
      @angular_velocity.vector.z = data['angular_velocity'][2]
    end

    def load_angular_acceleration(data)
      return unless data.key?('angular_acceleration')
      @angular_acceleration.vector.x = data['angular_acceleration'][0]
      @angular_acceleration.vector.y = data['angular_acceleration'][1]
      @angular_acceleration.vector.z = data['angular_acceleration'][2]
    end

    #
    # Create a cube object.
    # This is simply a raw cube loader.
    # An alias to load_raw ...
    #
    # @return [Boolean] Load cube object
    def create_cube
      data_path = BlackBook::Registry.instance.read('data_path')
      data_path = 'data' if data_path.nil?
      load_raw data_path + '/cube.raw'
    end

    #
    # Create a sphere object.
    # This is simply a raw sphere loader.
    # An alias to load_raw ...
    #
    # @return [Boolean] Load sphere object.
    def create_sphere
      data_path = BlackBook::Registry.instance.read('data_path')
      data_path = 'data' if data_path.nil?
      load_raw data_path + '/sphere.raw'
    end

    #
    # Add a face to the boejct
    # @param vertex_array [Array] Array of face data. (Creates a QUAD)
    #
    # @return [Boolean]
    def add_face(v_array)
      index = @vertices.count
      v_1 = CVector.new(v_array[0], v_array[1], v_array[2])
      v_2 = CVector.new(v_array[3], v_array[4], v_array[5])
      v_3 = CVector.new(v_array[6], v_array[7], v_array[8])
      @vertices << v_1
      @vertices << v_2
      @vertices << v_3
      @indices << CIndice.new(index, index + 1, index + 2, -1, -1, -1)
    end

    #
    # Load incoming array data into object.
    # This function is used inside recursive json scene loader.
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Boolean] Last operation is load_time and returns its result
    def load(data)
      load_mass data
      load_position data
      load_rotation data
      load_time data
      load_type data
      load_linear_velocity data
      load_linear_acceleration data
      load_angular_velocity data
      load_angular_acceleration data
      case @type
      when 1
        create_cube
      when 2
        create_sphere
      when 3
        load_raw data['filename']
      end
      x, y, z = data['scale'][0], data['scale'][1], data['scale'][2]
      @scale.set(x, y, z) if data.key?('scale')
    end

    #
    # Update min and max vectors
    # @param v [CVector] CVector added to object
    #
    # @return [CVector] Max Vector
    def update_min_max(v)
      @min.x = v.x if v.x < @min.x
      @min.y = v.y if v.y < @min.y
      @min.z = v.z if v.z < @min.z
      @max.x = v.x if v.x > @max.x
      @max.y = v.y if v.y > @max.y
      @max.z = v.z if v.z > @max.z
      @radius = @min.distance(@max) / 2.0
    end

    #
    # Build OpenGL List from faces
    #
    # @return [Float] Bounding radius of the object
    def build_list
      shader = BlackBook::Registry.instance.read('shader')
      shader = 'displaylist' if shader.nil?
      v1 = CVector.new(0, 0, 0, 1)
      v2 = v1.clone
      v3 = v1.clone
      case shader
      when 'displaylist'
        @index = GL.GenLists(1)
        GL.NewList(@index, GL::COMPILE)
        GL.LineWidth(2)
        i = 0
        @indices.each do |indice|
          v1 = @vertices[indice.v1]
          v2 = @vertices[indice.v2]
          v3 = @vertices[indice.v3]
          tex = false
          if indice.t1 + indice.t2 + indice.t3 >= 0
            t1 = @texcoords[indice.t1]
            t2 = @texcoords[indice.t2]
            t3 = @texcoords[indice.t3]
            tex = true
          end

          normal = BlackBook.calc_plane_normal(v1, v2, v3)
          GL.Begin(GL::QUADS)
          GL.Normal3f(normal.x, normal.y, normal.z)
          GL.TexCoord2f(t1.x, t1.y) if tex
          GL.Vertex3f(v1.x, v1.y, v1.z)

          GL.Normal3f(normal.x, normal.y, normal.z)
          GL.TexCoord2f(t2.x, t2.y) if tex
          GL.Vertex3f(v2.x, v2.y, v2.z)

          GL.Normal3f(normal.x, normal.y, normal.z)
          GL.TexCoord2f(t3.x, t3.y) if tex
          GL.Vertex3f(v3.x, v3.y, v3.z)
          GL.Normal3f(normal.x, normal.y, normal.z)
          GL.TexCoord2f(t1.x, t1.y) if tex
          GL.Vertex3f(v1.x, v1.y, v1.z)
          GL.End
          update_min_max(v1)
          update_min_max(v2)
          update_min_max(v3)
          i += 1
        end
        GL.EndList
      when 'vbo'
        @index = GL.GenBuffers(2)
        data = []
        normals = []
        @indices.each do |indice|
          v1 = @vertices[indice.v1]
          v2 = @vertices[indice.v2]
          v3 = @vertices[indice.v3]
          normal = BlackBook.calc_plane_normal(v1, v2, v3)
          data << v1.x
          data << v1.y
          data << v1.z
          data << v2.x
          data << v2.y
          data << v2.z
          data << v3.x
          data << v3.y
          data << v3.z
          1.upto(3) do |index|
            normals << normal.x
            normals << normal.y
            normals << normal.z
          end
          update_min_max(v1)
          update_min_max(v2)
          update_min_max(v3)
        end
        @data_size = data.length
        GL.BindBuffer(GL::GL_ARRAY_BUFFER, @index[0])
        GL.BufferData(
          GL::GL_ARRAY_BUFFER,
          data.length * 4,
          data.pack('f*'),
          GL::GL_STATIC_DRAW)
        GL.BindBuffer(GL::GL_ARRAY_BUFFER, @index[1])
        GL.BufferData(
          GL::GL_ARRAY_BUFFER,
          normals.length * 4,
          normals.pack('f*'),
          GL::GL_STATIC_DRAW
          )
      end
    end

    #
    # General rendering method.
    #
    # @return [Boolean] GL.PopMatrix is the last method called inside.
    def render
      build_list if @index == -1
      # GL.Disable(GL::LIGHTING)
      @material.start_render

      GL.PushMatrix
      GL.MultMatrixf(@matrix.to_array)


      shader = BlackBook::Registry.instance.read('shader')
      shader = 'displaylist' if shader.nil?
      case shader
      when 'displaylist'
        GL.CallList(@index)
      when 'vbo'
        GL.EnableClientState(GL::GL_VERTEX_ARRAY)
        GL.EnableClientState(GL::GL_NORMAL_ARRAY)
        GL.BindBuffer(GL::GL_ARRAY_BUFFER, @index[0])
        GL.VertexPointer(3, GL::GL_FLOAT, 0, 0)
        GL.BindBuffer(GL::GL_ARRAY_BUFFER, @index[1])
        GL.NormalPointer(GL::GL_FLOAT, 0, 0)
        GL.DrawArrays(GL::GL_TRIANGLES, 0, @data_size / 3)
        # GL.DrawElements(GL::TRIANGLES, @data_size / 3, GL::UNSIGNED_SHORT, 0)
        GL.DisableClientState(GL::GL_VERTEX_ARRAY)
        GL.DisableClientState(GL::GL_NORMAL_ARRAY)
        GL.Flush
      end

      GL.PopMatrix
      @material.end_render
      # GL.Enable(GL::LIGHTING)
    end

    #
    # Load Raw data object.
    # This is the RAW File Type of Blender software (http://www.blender.org/)
    # @param filename [String] File to be loaded.
    #
    # @return [Boolean] Return true on success
    def load_raw(filename)
      buffer = File.read filename
      buffer = buffer.split("\n")
      buffer.each do |line|
        items = line.split(' ')
        f_items = []
        items.each do |item|
          f_items.push item.to_f
        end
        add_face f_items
      end
      true
    end

    #
    # Load Text based Wavefront Object
    # This is the obj file type of Blender software (http://www.blender.org/)
    # @param [String] filename
    #
    # @return [Boolean] Return true on success
    def load_obj(filename)
      @vertices = []
      @texcoords = []
      @indices = []
      buffer = File.read filename
      buffer = buffer.split("\n")
      buffer.each do |line|
        items = line.split(' ')
        case items[0]
        when 'v'
          @vertices << CVector.new(items[1].to_f, items[2].to_f, items[3].to_f)
        when 'vt'
          @texcoords << CVector.new(items[1].to_f, items[2].to_f, 0)
        when 'f'
          p1 = items[1].split('/')
          p2 = items[2].split('/')
          p3 = items[3].split('/')
          @indices << CIndice.new(
            p1[0].to_i - 1,
            p2[0].to_i - 1,
            p3[0].to_i - 1,
            p1[1].to_i - 1,
            p2[1].to_i - 1,
            p3[1].to_i - 1
            )
        end
      end
    end
  end
end

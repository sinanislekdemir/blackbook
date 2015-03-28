################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'opengl'
require 'BlackBook/base'
require 'BlackBook/constants'
require 'BlackBook/stime'

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
  # @attr bounding_radius [Float] Radius of the bounding sphere
  # @attr min [CVector] Minimum coordinates
  # @attr max [CVector] Maximum coordinates
  #
  class B3DObject < Base
    attr_writer :faces, :mass, :roll, :pitch, :yaw,
                :position, :time, :name, :scale, :index, :bounding_radius,
                :min, :max, :data_size, :normal_index
    attr_accessor :faces, :mass, :roll, :pitch, :yaw,
                  :position, :time, :name, :scale, :index, :bounding_radius,
                  :min, :max, :data_size, :normal_index

    #
    # Initialize basic variables with default.
    #
    # @return [BB3DObject] return self
    def initialize
      @faces = []
      @bounding_radius, @mass, @roll, @pitch, @yaw = 0.0, 0.0, 0.0, 0.0, 0.0
      @position = CVector.new(0, 0, 0, 1)
      @scale = CVector.new(1, 1, 1, 1)
      @min, @max, @index = nil, nil, -1
      @time = STime.new
      @vertex_data = []
      @data_size = 0
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
      @position.x = data['position'][0] if data.key?('position')
      @position.y = data['position'][1] if data.key?('position')
      @position.z = data['position'][2] if data.key?('position')
    end

    #
    # Load Rotation Data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Float] Returns Yaw Flaot
    def load_rotation(data)
      @roll = data['roll'] if data.key?('roll')
      @pitch = data['pitch'] if data.key?('pitch')
      @yaw = data['yaw'] if data.key?('yaw')
    end

    #
    # Load Time Data
    # @param data [Hash] Load Data hash. (Recursive scene loading from json)
    #
    # @return [Float] Returns Time
    def load_time(data)
      @time = data['time'] if data.key?('time')
    end

    #
    # Create a cube object.
    # This is simply a raw cube loader.
    # An alias to load_raw ...
    #
    # @return [Boolean] Load cube object
    def create_cube
      load_raw 'data/cube.raw'
    end

    #
    # Create a sphere object.
    # This is simply a raw sphere loader.
    # An alias to load_raw ...
    #
    # @return [Boolean] Load sphere object.
    def create_sphere
      load_raw 'data/sphere.raw'
    end

    #
    # Add a face to the boejct
    # @param vertex_array [Array] Array of face data. (Creates a QUAD)
    #
    # @return [Boolean]
    def add_face(vertex_array)
      @faces.push(vertex_array)
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
    end

    #
    # Update min and max vectors
    # @param v [CVector] CVector added to object
    #
    # @return [CVector] Max Vector
    def update_min_max(v)
      if @min.nil?
        @min, @max = v, v
        return true
      end
      @min.x = v.x if v.x < @min.x
      @min.y = v.y if v.y < @min.y
      @min.z = v.z if v.z < @min.z
      @max.x = v.x if v.x > @max.x
      @max.y = v.y if v.y > @max.y
      @max.z = v.z if v.z > @max.z
    end

    #
    # Build OpenGL List from faces
    #
    # @return [Float] Bounding radius of the object
    def build_list
      shader = BlackBook::Registry.instance.read('shader')
      shader = 'displaylist' if shader.nil?
      v1, v2 = CVector.new(0, 0, 0, 1), CVector.new(0, 0, 0, 1)
      v3 = CVector.new(0, 0, 0, 1)
      case shader
      when 'displaylist'
        @index = GL.GenLists(1)
        @bounding_radius = 0.0
        GL.NewList(@index, GL::COMPILE)
        GL.LineWidth(2)
        @faces.each do |face|
          vertex_count = face.count / 3
          v1.x, v1.y, v1.z = face[0], face[1], face[2]
          v2.x, v2.y, v2.z = face[3], face[4], face[5]
          v3.x, v3.y, v3.z = face[6], face[7], face[8]
          normal = BlackBook.calc_plane_normal(v1, v2, v3)
          GL.Begin(GL::TRIANGLES)
          1.upto(vertex_count) do |index|
            i = (index - 1) * 3
            GL.Normal3f(normal.x, normal.y, normal.z)
            GL.Vertex3f(face[i], face[i + 1], face[i + 2])
          end
          GL.End
          update_min_max(v1)
          update_min_max(v2)
          update_min_max(v3)
        end
        GL.EndList
        @bounding_radius = @min.distance(@max)
      when 'vbo'
        @index = GL.GenBuffers(2)
        data = []
        normals = []
        @faces.each do |face|
          vertex_count = face.count / 3
          v1.x, v1.y, v1.z = face[0], face[1], face[2]
          v2.x, v2.y, v2.z = face[3], face[4], face[5]
          v3.x, v3.y, v3.z = face[6], face[7], face[8]
          normal = BlackBook.calc_plane_normal(v1, v2, v3)
          1.upto(vertex_count) do |index|
            i = (index - 1) * 3
            data << face[i]
            data << face[i + 1]
            data << face[i + 2]
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
      GL.Enable(GL::COLOR_MATERIAL)
      GL.Color3f(1.0, 1.0, 1.0)
      GL.PushMatrix
      GL.Translate(@position.x, @position.y, @position.z)
      GL.Rotate(@roll, 1, 0, 0)
      GL.Rotate(@pitch, 0, 1, 0)
      GL.Rotate(@yaw, 0, 0, 1)
      GL.Scale(@scale.x, @scale.y, @scale.z)

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
  end
end

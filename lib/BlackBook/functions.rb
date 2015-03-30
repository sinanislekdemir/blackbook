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
require 'pp'

# Local Libs
require 'BlackBook/constants'

# Mathematics related general functions
module BlackBook
  #
  # glhProjectf (works only from perspective projection.
  # With the orthogonal projection it gives different results than
  # standard gluProject.
  # https://www.opengl.org/wiki/GluProject_and_gluUnProject_code
  #
  # @param obj [CVector] Object Coordinates
  # @param mv [Array] Model View Matrix
  # @param p [Array] Projection Matrix
  # @param v [Array] Viewport Matrix
  #
  # @return [Array] Window Coordinates
  def glh_project_f(obj, mv, p, v)
    mv = mv.flatten
    p = p.flatten
    v = v.flatten
    # Transformation vector
    f = []
    # Modelview Transform
    f[0] = mv[0] * obj.x + mv[4] * obj.y + mv[8] * obj.z + mv[12]
    f[1] = mv[1] * obj.x + mv[5] * obj.y + mv[9] * obj.z + mv[13]
    f[2] = mv[2] * obj.x + mv[6] * obj.y + mv[10] * obj.z + mv[14]
    f[3] = mv[3] * obj.x + mv[7] * obj.y + mv[11] * obj.z + mv[15]
    # Projection transform the final row of projection
    # matrix is always [0 0 -1 0]
    # so we optimize for that.
    f[4] = p[0] * f[0] + p[4] * f[1] + p[8] * f[2] + p[12] * f[3]
    f[5] = p[1] * f[0] + p[5] * f[1] + p[9] * f[2] + p[13] * f[3]
    f[6] = p[2] * f[0] + p[6] * f[1] + p[10] * f[2] + p[14] * f[3]
    f[7] = -f[2]
    # The result normalizes between -1 and 1
    return [nil, nil] if f[7] == 0.0
    f[7] = 1.0 / f[7]
    # Perspective division
    f[4] *= f[7]
    f[5] *= f[7]
    f[6] *= f[7]
    # Window coordinates
    # Map x, y to range 0-1
    window_coordinate = []
    window_coordinate[0] = (f[4] * 0.5 + 0.5) * v[2] + v[0]
    window_coordinate[1] = (f[5] * 0.5 + 0.5) * v[3] + v[1]
    # This is only correct when glDepthRange(0.0, 1.0)
    window_coordinate[2] = (1.0 * f[6]) * 0.5
    window_coordinate
  end

  #
  # Multiply 4 x 4 matrices
  # @param m1 [Array] Array of 4x4 matrice
  # @param m2 [Array] Array of 4x4 matrice
  #
  # @return [Array] Result array
  def multiply_matrices_4by4(m1, m2)
    r = []
    r[0]  = m1[0] * m2[0]  + m1[4] * m2[1]  + m1[8]  * m2[2]  + m1[12] * m2[3]
    r[4]  = m1[0] * m2[4]  + m1[4] * m2[5]  + m1[8]  * m2[6]  + m1[12] * m2[7]
    r[8]  = m1[0] * m2[8]  + m1[4] * m2[9]  + m1[8]  * m2[10] + m1[12] * m2[11]
    r[12] = m1[0] * m2[12] + m1[4] * m2[13] + m1[8]  * m2[14] + m1[12] * m2[15]
    r[1]  = m1[1] * m2[0]  + m1[5] * m2[1]  + m1[9]  * m2[2]  + m1[13] * m2[3]
    r[5]  = m1[1] * m2[4]  + m1[5] * m2[5]  + m1[9]  * m2[6]  + m1[13] * m2[7]
    r[9]  = m1[1] * m2[8]  + m1[5] * m2[9]  + m1[9]  * m2[10] + m1[13] * m2[11]
    r[13] = m1[1] * m2[12] + m1[5] * m2[13] + m1[9]  * m2[14] + m1[13] * m2[15]
    r[2]  = m1[2] * m2[0]  + m1[6] * m2[1]  + m1[10] * m2[2]  + m1[14] * m2[3]
    r[6]  = m1[2] * m2[4]  + m1[6] * m2[5]  + m1[10] * m2[6]  + m1[14] * m2[7]
    r[10] = m1[2] * m2[8]  + m1[6] * m2[9]  + m1[10] * m2[10] + m1[14] * m2[11]
    r[14] = m1[2] * m2[12] + m1[6] * m2[13] + m1[10] * m2[14] + m1[14] * m2[15]
    r[3]  = m1[3] * m2[0]  + m1[7] * m2[1]  + m1[11] * m2[2]  + m1[15] * m2[3]
    r[7]  = m1[3] * m2[4]  + m1[7] * m2[5]  + m1[11] * m2[6]  + m1[15] * m2[7]
    r[11] = m1[3] * m2[8]  + m1[7] * m2[9]  + m1[11] * m2[10] + m1[15] * m2[11]
    r[15] = m1[3] * m2[12] + m1[7] * m2[13] + m1[11] * m2[14] + m1[15] * m2[15]
    r
  end

  #
  # Multiply matrix array with a vector array
  # Vector held as array for quick usage
  #
  # @param m [Array] Matrix
  # @param v [Array] Vector
  #
  # @return [Array] Result
  def multiply_matrix_by_vector(m, v)
    r = []
    r[0] = m[0] * v[0] + m[4] * v[1] + m[8] * v[2] + m[12] * v[3]
    r[1] = m[1] * v[0] + m[5] * v[1] + m[9] * v[2] + m[13] * v[3]
    r[2] = m[2] * v[0] + m[6] * v[1] + m[10] * v[2] + m[14] * v[3]
    r[3] = m[3] * v[0] + m[7] * v[1] + m[11] * v[2] + m[15] * v[3]
    r
  end

  #
  # Return array position from x-y coordinates
  # @param x [Integer] X Coordinate
  # @param y [Integer] Y Coordinate
  #
  # @return [Integer] Array index
  def _mat(x, y)
    y * 4 + (x)
  end

  #
  # Return item of matrix array from x-y coordinates
  # @param m [Array] Matrix
  # @param x [Integer] X Coordinate
  # @param y [Integer] Y Coordinate
  #
  # @return [type] [description]
  def mat(m, x, y)
    m[_mat(x, y)]
  end

  #
  # Invert matrix array
  # @param m [Array] Matrix
  #
  # @return [Array] Inverted matrix
  def glh_invert_matrix_f2(m)
    out = []
    r0, r1, r2, r3 = [], [], [], []
    r0[0] = mat(m, 0, 0)
    r0[1] = mat(m, 0, 1)
    r0[2] = mat(m, 0, 2)
    r0[3] = mat(m, 0, 3)
    r0[4] = 1.0
    r0[5] = r0[6] = r0[7] = 0.0
    r1[0] = mat(m, 1, 0)
    r1[1] = mat(m, 1, 1)
    r1[2] = mat(m, 1, 2)
    r1[3] = mat(m, 1, 3)
    r1[5] = 1.0
    r1[4] = r1[6] = r1[7] = 0.0
    r2[0] = mat(m, 2, 0)
    r2[1] = mat(m, 2, 1)
    r2[2] = mat(m, 2, 2)
    r2[3] = mat(m, 2, 3)
    r2[6] = 1.0
    r2[4] = r2[5] = r2[7] = 0.0
    r3[0] = mat(m, 3, 0)
    r3[1] = mat(m, 3, 1)
    r3[2] = mat(m, 3, 2)
    r3[3] = mat(m, 3, 3)
    r3[7] = 1.0
    r3[4] = r3[5] = r3[6] = 0.0
    r3, r2 = r2, r3 if r3[0].abs > r2[0]
    r2, r1 = r1, r2 if r2[0].abs > r1[0]
    r1, r0 = r0, r1 if r1[0].abs > r0[0]
    return 0 if r0[0] == 0.0
    m1 = r1[0] / r0[0]
    m2 = r2[0] / r0[0]
    m3 = r3[0] / r0[0]
    s = r0[1]
    r1[1] -= m1 * s
    r2[1] -= m2 * s
    r3[1] -= m3 * s
    s = r0[2]
    r1[2] -= m1 * s
    r2[2] -= m2 * s
    r3[2] -= m3 * s
    s = r0[3]
    r1[3] -= m1 * s
    r2[3] -= m2 * s
    r3[3] -= m3 * s
    s = r0[4]
    if s != 0.0
      r1[4] -= m1 * s
      r2[4] -= m2 * s
      r3[4] -= m3 * s
    end
    s = r0[5]
    if s != 0.0
      r1[5] -= m1 * s
      r2[5] -= m2 * s
      r3[5] -= m3 * s
    end
    s = r0[6]
    if s != 0.0
      r1[6] -= m1 * s
      r2[6] -= m2 * s
      r3[6] -= m3 * s
    end
    s = r0[7]
    if s != 0.0
      r1[7] -= m1 * s
      r2[7] -= m2 * s
      r3[7] -= m3 * s
    end
    r3, r2 = r2, r3 if r3[1].abs > r2[1].abs
    r2, r1 = r1, r2 if r2[1].abs > r1[1].abs
    return 0 if r1[1] == 0.0
    m2 = r2[1] / r1[1]
    m3 = r3[1] / r1[1]
    r2[2] -= m2 * r1[2]
    r3[2] -= m3 * r1[2]
    r2[3] -= m2 * r1[3]
    r3[3] -= m3 * r1[3]
    s = r1[4]
    if 0.0 != s
      r2[4] -= m2 * s
      r3[4] -= m3 * s
    end
    s = r1[5]
    if 0.0 != s
      r2[5] -= m2 * s
      r3[5] -= m3 * s
    end
    s = r1[6]
    if 0.0 != s
      r2[6] -= m2 * s
      r2[6] -= m3 * s
    end
    s = r1[7]
    if 0.0 != s
      r2[7] -= m2 * s
      r3[7] -= m3 * s
    end
    r3, r2 = r2, r3 if r3[2].abs > r2[2].abs
    return 0 if r2[2] == 0.0
    m3 = r3[2] / r2[2]
    r3[3] -= m3 * r2[3]
    r3[4] -= m3 * r2[4]
    r3[5] -= m3 * r2[5]
    r3[6] -= m3 * r2[6]
    r3[7] -= m3 * r2[7]
    return 0 if 0.0 == r3[3]
    s = 1.0 / r3[3]
    r3[4] *= s
    r3[5] *= s
    r3[6] *= s
    r3[7] *= s
    m2 = r2[3]
    s = 1.0 / r2[2]
    r2[4] = s * (r2[4] - r3[4] * m2)
    r2[5] = s * (r2[5] - r3[5] * m2)
    r2[6] = s * (r2[6] - r3[6] * m2)
    r2[7] = s * (r2[7] - r3[7] * m2)
    m1 = r1[3]
    r1[4] -= r3[4] * m1
    r1[5] -= r3[5] * m1
    r1[6] -= r3[6] * m1
    r1[7] -= r3[7] * m1
    m0 = r0[3]
    r0[4] -= r3[4] * m0
    r0[5] -= r3[5] * m0
    r0[6] -= r3[6] * m0
    r0[7] -= r3[7] * m0
    m1 = r1[2]
    s = 1.0 / r1[1]
    r1[4] = s * (r1[4] - r2[4] * m1)
    r1[5] = s * (r1[5] - r2[5] * m1)
    r1[6] = s * (r1[6] - r2[6] * m1)
    r1[7] = s * (r1[7] - r2[7] * m1)
    m0 = r0[2]
    r0[4] -= r2[4] * m0
    r0[5] -= r2[5] * m0
    r0[6] -= r2[6] * m0
    r0[7] -= r2[7] * m0
    m0 = r0[1]
    s = 1.0 / r0[0]
    r0[4] = s * (r0[4] - r1[4] * m0)
    r0[5] = s * (r0[5] - r1[5] * m0)
    r0[6] = s * (r0[6] - r1[6] * m0)
    r0[7] = s * (r0[7] - r1[7] * m0)
    out[_mat(0, 0)] = r0[4]
    out[_mat(0, 0)] = r0[4]
    out[_mat(0, 1)] = r0[5]
    out[_mat(0, 2)] = r0[6]
    out[_mat(0, 3)] = r0[7]
    out[_mat(1, 0)] = r1[4]
    out[_mat(1, 1)] = r1[5]
    out[_mat(1, 2)] = r1[6]
    out[_mat(1, 3)] = r1[7]
    out[_mat(2, 0)] = r2[4]
    out[_mat(2, 1)] = r2[5]
    out[_mat(2, 2)] = r2[6]
    out[_mat(2, 3)] = r2[7]
    out[_mat(3, 0)] = r3[4]
    out[_mat(3, 1)] = r3[5]
    out[_mat(3, 2)] = r3[6]
    out[_mat(3, 3)] = r3[7]
    out
  end

  #
  # GLU Unproject
  # https://www.opengl.org/wiki/GluProject_and_gluUnProject_code
  #
  # @param wx [Float] Window X Coordinate
  # @param wy [Float] Window Y Coordinate
  # @param wz [Float] Window Z Coordinate
  # @param m [Array] Model View Matrix
  # @param p [Array] Projection Matrix
  # @param v [Array] Viewport Matrix
  #
  # @return [CVector] Object coordinates
  def glh_unprojectf(wx, wy, wz, m, p, v)
    # Transformation matrices
    m_in = []
    # Calculation for inverting a matrix, compute projection x modelview
    # and store in A[16]
    m = m.flatten
    p = p.flatten
    v = v.flatten
    a = multiply_matrices_4by4(p, m)
    invert_m = glh_invert_matrix_f2(a)
    return 0 if invert_m == 0
    m_in[0] = (wx - v[0].to_f) / v[2].to_f * 2.0 - 1.0
    m_in[1] = (wy - v[1].to_f) / v[3].to_f * 2.0 - 1.0
    m_in[2] = 2.0 * wz - 1.0
    m_in[3] = 1.0
    out = multiply_matrix_by_vector(invert_m, m_in)
    return 0 if out[3] == 0
    out[3] = 1.0 / out[3]
    CVector.new(out[0] * out[3], out[1] * out[3], out[2] * out[3])
  end

  #
  # Cross Product of two vectors
  # @param x1 [Float] [X1 Element of vector]
  # @param y1 [Float] [Y1 Element of vector]
  # @param z1 [Float] [Z1 Element of vector]
  # @param x2 [Float] [X2 Element of vector]
  # @param y2 [Float] [Y2 Element of vector]
  # @param z2 [Float] [Z2 Element of vector]
  #
  # @return [Array] Array of vector elements [x, y, z]
  def cross_prod(x1, y1, z1, x2, y2, z2)
    [(y1 * z2 - y2 * z1), (x2 * z1 - x1 * z2), (x1 * y2 - x2 * y1)]
  end

  #
  # GLULookAt Alternative Function
  # @param eye [CVector] [Eye position]
  # @param look_at [CVector] [Target position]
  # @param up [CVector] [Up vector of camera]
  #
  # @return [Boolean] Success
  def look_at(eye, look_at, up)
    z = CVector.new(eye.x - look_at.x, eye.y - look_at.y, eye.z - look_at.z, 1)
    z.normalize
    y = CVector.new(up.x, up.y, up.z, 1)
    x = y.cross(z)
    y = z.cross(x)
    x.normalize
    y.normalize
    mat = [x.x, y.x, z.x, 0, x.y, y.y, z.y, 0, x.z, y.z, z.z, 0, 0, 0, 0, 1]
    GL.MultMatrixf(mat)
    GL.Translatef(-eye.x, -eye.y, -eye.z)
  end

  #
  # GLUPerspective Alternative
  # @param fovY [Float] Field of view
  # @param aspect [Float] Aspect ratio of view
  # @param znear [Float] Near Plane
  # @param zfar [Float] Far Plane
  #
  # @return [Boolean] Success
  def perspective(fovY, aspect, znear, zfar)
    pi = 3.1415926535897932384626433832795
    fh = Math.tan((fovY / 2) / 180 * pi) * znear
    fw = fh * aspect
    GL.Frustum(-fw, fw, -fh, fh, znear, zfar)
  end

  #
  # Draw grid
  #
  # @return [Boolean] Success
  def draw_grid
    count = BlackBook::Registry.instance.read('grid_count')
    count = 200 if count.nil?
    GL.PushMatrix
    GL.Translatef(0.0, 0.0, 0.0)

    GL.Disable(GL::LIGHTING)
    GL.Color3f(0.8, 0.8, 0.8)
    1.upto(200) do |i|
      GL.Begin(GL::LINES)
      GL.Vertex(i - 100, -100, 0)
      GL.Vertex(i - 100, 100, 0)
      GL.End()
      GL.Begin(GL::LINES)
      GL.Vertex(-100, i - 100, 0)
      GL.Vertex(100, i - 100, 0)
      GL.End()
    end
    GL.LineWidth 3
    GL.Color3f(1.0, 0.0, 0.0)
    GL.Begin(GL::LINES)
    GL.Vertex3f(0, 0, 0)
    GL.Vertex3f(100.0, 0, 0)
    GL.End
    GL.Color3f(0.0, 1.0, 0.0)
    GL.Begin(GL::LINES)
    GL.Vertex3f(0, 0, 0)
    GL.Vertex3f(0.0, 100.0, 0)
    GL.End
    GL.Color3f(0.0, 0.0, 1.0)
    GL.Begin(GL::LINES)
    GL.Vertex3f(0, 0, 0)
    GL.Vertex3f(0.0, 0.0, 100.0)
    GL.End
    GL.LineWidth 1

    GL.Enable(GL::LIGHTING)
    GL.PopMatrix
  end

  #
  # CVector to color.
  # RGBA (0-255, 0-255, 0-255, 0-1)
  # @param color_vector [CVector] Color vector
  #
  # @return [Boolean] Success
  def apply_color(color_vector)
    r = color_vector.x == 0 ? 0 : color_vector.x / 255.0
    g = color_vector.y == 0 ? 0 : color_vector.y / 255.0
    b = color_vector.z == 0 ? 0 : color_vector.z / 255.0
    GL.Color4f(
      r,
      g,
      b,
      color_vector.w
      )
  end

  #
  # Draw 2D Box
  # @param options [Hash]
  #   options[:x, :y, :z, :w, :color, :border, :border_color]
  #
  # @return [Boolean] Success
  def draw_box_2d(options)
    GL.PushMatrix
    GL.Disable(GL::LIGHTING)
    GL.Enable(GL::COLOR_MATERIAL)
    GL.Enable(GL::BLEND)
    GL.BlendFunc(GL::SRC_ALPHA, GL::ONE_MINUS_SRC_ALPHA)
    GL.Translatef(options[:x], options[:y], options[:z])
    # Border
    if options.key?(:border) && options[:border]
      apply_color(options[:border_color]) if options.key?(:border_color)
      line_width = options.key?(:border_size) ? options[:border_size] : 1
      GL.LineWidth(line_width)
      GL.Begin(GL::LINE_STRIP)
      GL.Vertex2d(-line_width, -line_width)
      GL.Vertex2d(-line_width, options[:height] + line_width)
      GL.Vertex2d(options[:width] + line_width, options[:height] + line_width)
      GL.Vertex2d(options[:width] + line_width, -line_width)
      GL.Vertex2d(-line_width, -line_width)
      GL.End
    end
    # Window
    apply_color(options[:color])
    GL.Begin(GL::QUADS)
    GL.Vertex2d(0, 0)
    GL.Vertex2d(0, options[:height])
    GL.Vertex2d(options[:width], options[:height])
    GL.Vertex2d(options[:width], 0)
    GL.End
    GL.PopMatrix
  end

  #
  # Degrees to Radians Conversion
  # @param degrees [Float] Degrees
  #
  # @return [Float] Radians
  def deg_to_rad(degrees)
    degrees * (Math::PI / 180.0)
  end

  #
  # Radians to Degrees
  # @param radians [Float] Radians
  #
  # @return [Float] Degrees
  def rad_to_deg(radians)
    result = radians * (180.0 / Math::PI)
    result = 360.0 + result if result < 0
    result = 360.0 - result if result > 360.0
    result
  end

  #
  # Calculate Normal of a given Triangle
  # @param p1 [CVector] Triangle Vector A
  # @param p2 [CVector] Triangle Vector B
  # @param p3 [CVector] Triangle Vector C
  #
  # @return [CVector] Normal Vector
  def calc_plane_normal(p1, p2, p3)
    v1 = p2.sub(p1)
    v2 = p3.sub(p1)
    result = v1.cross(v2)
    result.normalize
    result
  end

  #
  # Convert Array to Vector
  # @param data [Array] Array of floats
  #
  # @return [CVector] Result Vector
  def array_to_vector(data)
    CVector.new(data[0], data[1], data[2], 1)
  end

  #
  # Draw Circle
  # @param r [Float] Radius
  # @param num_segments [Integer] Number of segments
  #
  # @return [type] [description]
  def draw_circle(r, num_segments)
    pi = 3.1415926535897932384626433832795
    GL.Begin(GL::LINE_LOOP)
    (0..num_segments).each do |ii|
      theta = 2.0 * pi * ii.to_f / num_segments.to_f
      x = r * Math.cos(theta)
      y = r * Math.sin(theta)
      GL.Vertex2f(x, y)
    end
    GL.End
  end
end

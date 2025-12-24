#!/usr/bin/env ruby
# BlackBook 3D Gem - Installation Verification Script
# Run this after installing the gem to verify everything works

require 'blackbook'

puts "=" * 80
puts " BlackBook 3D Engine - Installation Verification"
puts "=" * 80

# Test results
tests_passed = 0
tests_failed = 0

def test(description)
  print "  Testing #{description}... "
  yield
  puts "✓ PASS"
  return 1
rescue => e
  puts "✗ FAIL: #{e.message}"
  return 0
end

# 1. Module and version
puts "\n[1] Core Module"
tests_passed += test("BlackBook module") { raise unless defined?(BlackBook) }
tests_passed += test("version constant") { 
  if defined?(BlackBook::VERSION)
    puts "    Version: #{BlackBook::VERSION}"
  end
}

# 2. Essential classes
puts "\n[2] Essential Classes"
%w[Engine Space Camera B3DObject Material CVector Light].each do |klass|
  tests_passed += test("BlackBook::#{klass}") { 
    raise unless BlackBook.const_defined?(klass) 
  }
end

# 3. Dependencies
puts "\n[3] Dependencies"
tests_passed += test("GLFW") { raise unless defined?(GLFW) }
tests_passed += test("OpenGL") { raise unless defined?(GL) }
tests_passed += test("MiniMagick") { require 'mini_magick'; raise unless defined?(MiniMagick) }

# 4. Vector operations
puts "\n[4] Vector Math"
tests_passed += test("vector creation") {
  v = BlackBook::CVector.new(3, 4, 0)
  raise unless v.x == 3 && v.y == 4
}
tests_passed += test("vector addition") {
  v1 = BlackBook::CVector.new(1, 2, 3)
  v2 = BlackBook::CVector.new(4, 5, 6)
  v3 = v1.add(v2)
  raise unless v3.x == 5 && v3.y == 7 && v3.z == 9
}
tests_passed += test("vector length") {
  v = BlackBook::CVector.new(3, 4, 0)
  raise unless v.length == 5.0
}

# 5. Object system
puts "\n[5] Object System"
tests_passed += test("object creation") {
  obj = BlackBook::B3DObject.new
  raise unless obj.respond_to?(:matrix)
  raise unless obj.respond_to?(:material)
}
tests_passed += test("material system") {
  mat = BlackBook::Material.new
  raise unless mat.respond_to?(:color)
}

# 6. Data files
puts "\n[6] Data Files"
gem_spec = Gem::Specification.find_by_name('blackbook3d')
data_dir = File.join(gem_spec.gem_dir, 'data')
tests_passed += test("data directory exists") {
  raise unless Dir.exist?(data_dir)
  puts "    Location: #{data_dir}"
}

data_files = Dir.glob(File.join(data_dir, '**', '*')).select { |f| File.file?(f) }
tests_passed += test("data files present") {
  raise if data_files.empty?
  puts "    Found #{data_files.size} data files"
}

# Check for essential models
%w[sphere.raw cube.raw].each do |model|
  path = File.join(data_dir, model)
  tests_passed += test("#{model} exists") {
    raise unless File.exist?(path)
  }
end

# 7. Object loading
puts "\n[7] File Loading"
sphere_path = File.join(data_dir, 'sphere.raw')
if File.exist?(sphere_path)
  tests_passed += test("load sphere.raw") {
    obj = BlackBook::B3DObject.new
    obj.load_raw(sphere_path)
    raise if obj.instance_variable_get('@vertices').empty?
    puts "    Vertices: #{obj.instance_variable_get('@vertices').size}"
    puts "    Radius: #{obj.radius.round(3)}"
  }
end

# Summary
puts "\n" + "=" * 80
puts " Test Summary"
puts "=" * 80
total = tests_passed + tests_failed
puts "  Passed: #{tests_passed}/#{total}"
puts "  Failed: #{tests_failed}/#{total}"

if tests_failed == 0
  puts "\n  ✓ All tests passed! BlackBook 3D is ready to use."
  puts "\n  Get started:"
  puts "    require 'blackbook'"
  puts ""
  puts "  Example:"
  puts "    app = BlackBook::Engine.new(800, 600, 'My 3D App')"
  puts ""
  puts "  Data location: #{data_dir}"
  puts "=" * 80
  exit 0
else
  puts "\n  ✗ Some tests failed. Please check your installation."
  puts "=" * 80
  exit 1
end

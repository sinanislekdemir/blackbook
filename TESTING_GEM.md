# Testing BlackBook Gem Before Publishing

## Quick Test Process

### 1. Install the gem locally

```bash
gem install ./blackbook3d-0.5.0.gem --local
```

### 2. Run the verification script

```bash
ruby verify_gem_install.rb
```

This will test:
- ✓ Core module loading
- ✓ All essential classes
- ✓ Dependencies (GLFW, OpenGL, MiniMagick)
- ✓ Vector math operations
- ✓ Object system
- ✓ Data files present and loadable
- ✓ 3D model loading

### 3. Test in a clean environment

Create a test script in a different directory:

```ruby
# /tmp/test_blackbook.rb
require 'blackbook'

module BlackBook
  class TestApp < Engine
    def initialize
      super(800, 600, 'Test')
      @space = Space.new(@viewport_x, @viewport_y)
      
      camera = @space.add_camera(
        eye_position: CVector.new(10, 10, 10),
        up: CVector.new(0, 0, 1),
        target_position: CVector.new(0, 0, 0)
      )
      
      light = @space.create_light
      light.position.set(5, 5, 10)
      
      # Load a model from gem data
      gem_dir = Gem::Specification.find_by_name('blackbook3d').gem_dir
      sphere = File.join(gem_dir, 'data', 'sphere.raw')
      
      obj = @space.add_object(filename: sphere, name: 'test_sphere')
      obj.material.color.set(1.0, 0.0, 0.0, 1.0)
      
      puts "✓ App created successfully"
      Thread.new { sleep 2; @main_window.close }
    end
    
    def render
      super
      @space.init_gl unless @space.gl_active
      @space.render
    end
  end
end

BlackBook::TestApp.new.engine_loop
puts "✓ Test completed!"
```

Run it:
```bash
cd /tmp
ruby test_blackbook.rb
```

### 4. Test with RVM gemset (optional)

Create a fresh gemset to test in isolation:

```bash
rvm gemset create blackbook-test
rvm use @blackbook-test
gem install ./blackbook3d-0.5.0.gem --local
ruby verify_gem_install.rb
```

### 5. Uninstall and test again

```bash
gem uninstall blackbook3d
gem install ./blackbook3d-0.5.0.gem --local
ruby verify_gem_install.rb
```

## What Gets Tested

### Core Functionality
- [x] Module loading
- [x] Class availability
- [x] Vector math (add, subtract, length, normalize)
- [x] 3D object creation
- [x] Material system
- [x] Camera setup
- [x] Light system

### Dependencies
- [x] GLFW (window management)
- [x] OpenGL (rendering)
- [x] MiniMagick (texture loading)
- [x] RubyZip (archive support)

### Data Files
- [x] Data directory included
- [x] 3D models accessible (sphere.raw, cube.raw, etc.)
- [x] Texture files included
- [x] File loading works

### Real Usage
- [x] Engine initialization
- [x] Space creation
- [x] Camera setup
- [x] Object loading from gem data
- [x] Rendering loop
- [x] Window creation/destruction

## Expected Output

All tests should show:
```
✓ All tests passed! BlackBook 3D is ready to use.
Passed: 22/22
Failed: 0/22
```

## Common Issues and Fixes

### "Cannot load file 'blackbook'"
- Make sure gem is installed: `gem list blackbook`
- Check Ruby version: `ruby --version` (need >= 3.0)

### "Cannot find data files"
- Verify data included in gem: `gem contents blackbook3d | grep data`
- Check gem location: `gem env gemdir`

### GLFW errors
- Install system dependency: `sudo apt-get install libglfw3-dev`

### MiniMagick errors  
- Install ImageMagick: `sudo apt-get install imagemagick`

## Ready to Publish?

If all tests pass:

```bash
# Sign in to RubyGems (first time only)
gem signin

# Push the gem
gem push blackbook3d-0.5.0.gem
```

Then test the published version:

```bash
gem uninstall blackbook3d
gem install blackbook3d
ruby verify_gem_install.rb
```

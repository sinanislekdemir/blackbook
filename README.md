# BlackBook 3D Engine

[![Gem Version](https://badge.fury.io/rb/blackbook3d.svg)](https://badge.fury.io/rb/blackbook3d)
[![Ruby](https://img.shields.io/badge/ruby-%3E%3D%203.0-ruby.svg)](https://www.ruby-lang.org)
[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

A pure Ruby 3D rendering engine built on OpenGL. Write 3D applications with the simplicity and elegance of Ruby.

![BlackBook Sample](https://raw.github.com/sinanislekdemir/blackbook/master/sample.png)

## Features

- 🎮 **Pure Ruby** - No C++ required, write everything in Ruby
- 🎨 **OpenGL Rendering** - Hardware-accelerated 3D graphics
- 📦 **3D Model Loading** - Import .obj and .raw formats from Blender
- 🎯 **Physics Simulation** - Collision detection with sphere-to-sphere physics
- 🎬 **Camera System** - Mouse-controlled camera with multiple view support
- 💡 **Lighting** - Multiple light sources with material support
- 🖼️ **Texture Mapping** - Load and apply textures to 3D objects
- 🧮 **Vector Math** - Complete 3D vector and matrix library
- 🎪 **UI System** - Built-in UI for creating windows, buttons, and controls

## Installation

### From RubyGems (Recommended)

```bash
gem install blackbook3d
```

Or add to your Gemfile:

```ruby
gem 'blackbook3d', '~> 0.5.0'
```

### System Dependencies

**Ubuntu/Debian:**
```bash
sudo apt-get install libglfw3-dev imagemagick
```

**macOS:**
```bash
brew install glfw imagemagick
```

**Arch Linux:**
```bash
sudo pacman -S glfw imagemagick
```

## Quick Start

```ruby
require 'blackbook'

module BlackBook
  class MyApp < Engine
    def initialize
      super(800, 600, 'My 3D App')
      
      # Create a 3D space
      @space = Space.new(@viewport_x, @viewport_y)
      
      # Add a camera
      @space.add_camera(
        eye_position: CVector.new(10, 10, 10),
        up: CVector.new(0, 0, 1),
        target_position: CVector.new(0, 0, 0)
      )
      
      # Add a light
      light = @space.create_light
      light.position.set(5, 5, 10)
      
      # Load and add a 3D object
      gem_dir = Gem::Specification.find_by_name('blackbook3d').gem_dir
      sphere = File.join(gem_dir, 'data', 'sphere.raw')
      
      obj = @space.add_object(filename: sphere, name: 'my_sphere')
      obj.material.color.set(1.0, 0.3, 0.3, 1.0)  # Red color
    end
    
    def render
      super
      @space.init_gl unless @space.gl_active
      @space.render
    end
  end
end

# Run the application
MyApp.new.engine_loop
```

Save as `my_app.rb` and run:
```bash
ruby my_app.rb
```

## Examples

Check out the [samples](samples/) directory for more examples:

- **1_simple.rb** - Basic empty scene
- **3_first_object.rb** - Loading and displaying 3D objects
- **6_multiple_lights.rb** - Working with multiple light sources
- **14_texture.rb** - Applying textures to objects
- **15_bouncing_balls.rb** - Physics simulation with collision detection

Run any sample:
```bash
cd samples
ruby 15_bouncing_balls.rb
```

## Configuration

Configure global settings using the Registry:

```ruby
BlackBook::Registry.setup(
  grid: true,           # Show grid
  grid_count: 100,      # Number of grid lines
  grid_size: 2,         # Grid line spacing
  shader: 'vbo'         # Rendering mode: 'vbo' or 'displaylist'
)
```

## Creating 3D Models

### From Blender

BlackBook supports standard 3D formats:

**Wavefront OBJ Format:**
1. Export from Blender as `.obj`
2. Set Forward: Y Forward, Up: Z Up
3. Load with `space.add_object(filename: 'model.obj')`

**RAW Format:**
1. Export from Blender as RAW triangle format
2. Load with `space.add_object(filename: 'model.raw')`

![Blender Export Settings](https://raw.github.com/sinanislekdemir/blackbook/master/obj_export.png)

## Architecture

```
Engine
  └── Space (3D Scene)
      ├── Camera (Multiple cameras supported)
      ├── Light (Multiple lights)
      ├── B3DObject (3D Models)
      │   └── Material (Colors, Textures)
      └── UI (Windows, Buttons, Labels)
```

### Key Classes

- **`Engine`** - Window and main loop management
- **`Space`** - 3D scene container
- **`Camera`** - View and projection handling
- **`B3DObject`** - 3D meshes with transform matrices
- **`Material`** - Colors and texture properties
- **`CVector`** - 3D vector math
- **`Light`** - Light sources

## Physics & Collision

BlackBook includes basic physics simulation:

```ruby
# Objects automatically calculate bounding sphere radius
obj = space.add_object(filename: 'sphere.raw')
puts obj.radius  # Calculated from vertices

# Implement collision detection in your update loop
if ball1.position.distance(ball2.position) < ball1.radius + ball2.radius
  # Handle collision
end
```

See [samples/15_bouncing_balls.rb](samples/15_bouncing_balls.rb) for a complete example.

## Camera Controls

Built-in mouse camera controls:

- **Left Mouse Button + Drag** - Rotate camera around target
- Camera movement is automatic in the default implementation
- Override `mouse_move` in your Engine subclass for custom controls

## Documentation

Generate full API documentation:

```bash
gem install yard
yard doc
```

View the documentation:
```bash
yard server
```

Then open http://localhost:8808

## Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing`)
3. Commit your changes (`git commit -am 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing`)
5. Open a Pull Request

### Development Setup

```bash
git clone https://github.com/sinanislekdemir/blackbook.git
cd blackbook
bundle install
ruby samples/1_simple.rb
```

## Known Issues

- Physics engine needs refactoring (contributions welcome!)
- Display lists are used by default (VBOs available but not default)
- Some UI components are work in progress

## Version History

### v0.5.0 (2025-12-24) - First RubyGems Release
- ✨ Published to RubyGems.org
- ✨ Modernized for Ruby 3.4+
- ✨ Replaced abandoned `glfw3` with `glfw` 3.3.2
- ✨ Switched from RMagick to MiniMagick
- 🐛 Fixed window resizing and viewport updates
- 🐛 Fixed texture loading with modern ImageMagick
- 🎯 Added automatic radius calculation for collision detection
- 🎯 Improved sphere-to-sphere collision physics
- 📦 Included 103 data files (models, textures, fonts)

See [RELEASE_NOTES_v0.5.0.md](RELEASE_NOTES_v0.5.0.md) for complete details.

## Requirements

- Ruby >= 3.0.0
- GLFW 3.x (system library)
- ImageMagick (for texture loading)
- OpenGL support in your graphics driver

## License

GNU General Public License v2.0

See [LICENSE](LICENSE) for details.

## Credits

**Author:** Sinan ISLEKDEMIR ([@sinanislekdemir](https://github.com/sinanislekdemir))

**Contributors:**
- [@DarkSpyCyber](https://github.com/DarkSpyCyber) - Animation system and frames support
- [@alx3dev](https://github.com/alx3dev) - Code improvements and refactoring
- GitHub Copilot - Modernization assistance (v0.5.0)

**Want to contribute?** PRs are welcome!

## Links

- **RubyGems:** https://rubygems.org/gems/blackbook3d
- **GitHub:** https://github.com/sinanislekdemir/blackbook
- **Issues:** https://github.com/sinanislekdemir/blackbook/issues

---

Made with ❤️ and Ruby. Perfect for learning 3D graphics or building small 3D visualizations without leaving Ruby.


# Building and Publishing BlackBook as a Gem

## Quick Start - Publishing to RubyGems.org

### 1. Sign in to RubyGems (first time only)

```bash
gem signin
```

Enter your RubyGems.org credentials.

### 2. Push the gem

```bash
gem push blackbook3d-0.5.0.gem
```

That's it! Your gem is now published.

---

## Building the Gem

```bash
gem build blackbook3d.gemspec
```

Creates `blackbook3d-0.5.0.gem` (5.2 MB).

## Testing Locally Before Publishing

```bash
# Install locally
gem install ./blackbook3d-0.5.0.gem --local

# Run verification
ruby verify_gem_install.rb

# Quick test
ruby -e "require 'blackbook'; puts 'Works!'"
```

## Using the Published Gem

Once published, anyone can install:

```bash
gem install blackbook3d
```

Or in a Gemfile:

```ruby
gem 'blackbook3d', '~> 0.5.0'
```

## Quick Example

```ruby
require 'blackbook'

module BlackBook
  class MyApp < Engine
    def initialize
      super(800, 600, 'My 3D App')
      @space = Space.new(@viewport_x, @viewport_y)
      
      @space.add_camera(
        eye_position: CVector.new(10, 10, 10),
        up: CVector.new(0, 0, 1),
        target_position: CVector.new(0, 0, 0)
      )
      
      light = @space.create_light
      light.position.set(5, 5, 10)
      
      # Load models from gem data
      gem_dir = Gem::Specification.find_by_name('blackbook3d').gem_dir
      sphere = File.join(gem_dir, 'data', 'sphere.raw')
      
      obj = @space.add_object(filename: sphere, name: 'ball')
      obj.material.color.set(1.0, 0.0, 0.0, 1.0)
    end
    
    def render
      super
      @space.init_gl unless @space.gl_active
      @space.render
    end
  end
end

MyApp.new.engine_loop
```

## Updating the Gem (New Version)

1. Edit version in `blackbook3d.gemspec`:
   ```ruby
   spec.version = '0.5.1'
   ```

2. Rebuild and push:
   ```bash
   gem build blackbook3d.gemspec
   gem push blackbook3d-0.5.1.gem
   ```

## Gem Contents

- All Ruby code from `lib/`
- 3D models and textures from `data/` (103 files)
- Documentation (README.md, SETUP.md, LICENSE)
- Dependencies: glfw, opengl, mini_magick, rubyzip

## System Requirements

Users need to install system dependencies:

**Ubuntu/Debian:**
```bash
sudo apt-get install libglfw3-dev imagemagick
```

**macOS:**
```bash
brew install glfw imagemagick
```

**Ruby:**
```bash
ruby >= 3.0.0
```

## Troubleshooting

### Gem won't build
```bash
# Check gemspec syntax
ruby -c blackbook3d.gemspec
```

### Can't push - not authorized
```bash
# Re-authenticate
gem signin
```

### Want to unpublish (within 24 hours)
```bash
gem yank blackbook3d -v 0.5.0
```

## RubyGems Account

Sign up at: https://rubygems.org/sign_up

Once published, view your gem at:
https://rubygems.org/gems/blackbook3d


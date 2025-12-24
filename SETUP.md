# BlackBook Setup Guide

## Modernized for Ruby 3.4+ (December 2025)

This project has been updated to work with modern Ruby (3.4+) and latest gem dependencies.

### Prerequisites

- Ruby 3.0 or higher (tested with Ruby 3.4.8)
- Bundler 4.0+
- GLFW library (system-level)
- ImageMagick (system-level, for texture loading)

### System Dependencies

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get install libglfw3-dev imagemagick
```

#### macOS
```bash
brew install glfw imagemagick
```

### Ruby Dependencies

Install all Ruby gems:
```bash
bundle install
```

### Running the Project

```bash
ruby main.rb
```

The application will open an OpenGL window with your 3D scene.

### What Changed (Modernization Notes)

1. **GLFW**: Migrated from `glfw3` gem (0.4.8, abandoned) to `glfw` gem (3.3.2.0, actively maintained)
   - API changes: `Glfw` → `GLFW`, callback methods updated to block-based API
   
2. **ImageMagick**: Migrated from `rmagick` to `mini_magick` 
   - Lighter weight, no native extensions, uses command-line ImageMagick
   
3. **Ruby Version**: Updated Gemfile to require Ruby >= 3.0.0

4. **Bundler**: Removed old lockfile, regenerated for Bundler 4.0+

### Troubleshooting

If you encounter issues with GLFW:
- Ensure GLFW 3.x is installed system-wide
- Check that pkg-config can find it: `pkg-config --modversion glfw3`

If textures don't load:
- Verify ImageMagick is installed: `which convert`
- Check that your image files are in the correct format

### API Documentation

Run `yard` to generate documentation:
```bash
yard doc
```

Then open `doc/index.html` in your browser.

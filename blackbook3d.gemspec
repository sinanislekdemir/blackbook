# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'blackbook3d'
  spec.version       = '0.5.0'
  spec.authors       = ['Sinan ISLEKDEMIR']
  spec.email         = ['sinan@islekdemir.com']

  spec.summary       = 'Pure Ruby 3D Engine'
  spec.description   = 'BlackBook is a pure Ruby 3D library that enables developers to write 3D applications with the ease of Ruby. Features include OpenGL rendering, physics simulation, camera controls, and material/texture support.'
  spec.homepage      = 'https://github.com/sinanislekdemir/blackbook'
  spec.license       = 'GPL-2.0'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/sinanislekdemir/blackbook'
  spec.metadata['changelog_uri'] = 'https://github.com/sinanislekdemir/blackbook/blob/master/README.md'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob([
    'lib/**/*.rb',
    'data/**/*',
    'LICENSE',
    'README.md',
    'SETUP.md'
  ])
  
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_runtime_dependency 'glfw', '~> 3.3'
  spec.add_runtime_dependency 'opengl', '~> 0.10'
  spec.add_runtime_dependency 'mini_magick', '~> 5.3'
  spec.add_runtime_dependency 'rubyzip', '~> 3.0'

  # Development dependencies
  spec.add_development_dependency 'yard', '~> 0.9'

  spec.post_install_message = <<~MESSAGE
    
    ====================================================================
    Thank you for installing BlackBook 3D Engine!
    
    This version has been modernized for Ruby 3.4+ with updated gems:
    - GLFW 3.3.2 (modern window/input handling)
    - MiniMagick (lightweight texture loading)
    - Updated APIs and improved collision detection
    
    Get started:
      require 'blackbook'
      
    View samples: https://github.com/sinanislekdemir/blackbook/tree/master/samples
    Documentation: Run 'yard doc' to generate docs
    
    System dependencies (Ubuntu/Debian):
      sudo apt-get install libglfw3-dev imagemagick
    ====================================================================
    
  MESSAGE
end

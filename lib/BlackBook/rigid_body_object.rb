################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'BlackBook/space_object'

module BlackBook
  # rigid body
  class RigidBodyObject < SpaceObject
    def initialize
      super
      @type = SOLID_MESH
    end
  end
end

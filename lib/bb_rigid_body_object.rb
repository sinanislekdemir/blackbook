################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

# Local Libs
require 'bb_space_object'

# rigid body
class BBRigidBodyObject < BBSpaceObject
  def initialize
    super
    @type = SOLID_MESH
  end
end

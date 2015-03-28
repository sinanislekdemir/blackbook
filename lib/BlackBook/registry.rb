require 'singleton'
require 'json'

# Blackbook Registry for global variables
module BlackBook
  # Singleton Registry class
  class Registry
    include Singleton

    attr_writer :params
    attr_accessor :params

    # Create empty hash
    def initialize
      @params = {}
    end

    # read object from hash, return nil if not found
    def read(key)
      @params.key?(key) ? @params[key] : nil
    end

    # write to instance hash
    def write(key, value)
      @params[key] = value
    end

    # actually just a shortcut :)
    def exists(key)
      @params.key? key
    end

    # save current parameters to file as json
    def save_to_file(filename)
      File.write filename, @params.to_json
    end

    # load from json file
    def load_from_file(filename)
      buffer = File.read(filename)
      @params = JSON.parse(buffer)
    end
  end
end

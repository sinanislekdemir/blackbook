require 'singleton'
require 'json'

module BlackBook
  class Registry
    include Singleton

    attr_writer :params
    attr_accessor :params

    def create
      @params = {}
    end

    def read(key)
      return @params.key?(key) ? @params[key] : nil
    end

    def write(key, value)
      @params[key] = value
    end

    def save_to_file(filename)
      File.open(filename, "w") do |f|
        f.write @params.to_json
      end
    end

    def load_from_file(filename)
      buffer = File.read(filename)
      @params = JSON.parse(buffer)
    end
  end
end

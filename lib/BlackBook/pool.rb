require 'singleton'

module BlackBook
  class Pool
    include Singleton

    def initialize
      @data = {}
    end

    def add(key, value)
      @data[key] = value
    end

    def delete(key)
      @data.delete key
    end

    def get(key)
      @data.key?(key) ? @data[key] : nil
    end

    def exists(key)
      @data.key? key
    end
  end
end

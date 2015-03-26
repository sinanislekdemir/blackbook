################################################################
# Project BlackBook
# Lead Engineer: Sinan ISLEKDEMIR
# Simulation Engine Ruby Sources
################################################################

require 'pp'
require 'singleton'

module BlackBook
  # Application-wide logging class
  class Logger
    include Singleton
    attr_accessor :filename, :stdout, :file

    def initialize
    end

    def define(args)
      @file = nil # There has to be only one file instance
      if args.key?(:filename)
        @filename = args[:filename]
        @file = File.open(@filename, 'a')
      end
      @stdout = args.key?(:stdout) && args[:stdout]
    end

    def warning(message)
      @file.printf "%-27s - %-10s : %s \n",
                    Time.now.to_s,
                    'WARNING',
                    message unless @file.nil?
      printf "%-10s : %s\n", 'WARNING', message if @stdout
    end

    def error(message)
      @file.printf "%-27s - %-10s : %s \n",
                    Time.now.to_s,
                    'ERROR',
                    message unless @file.nil?
      printf "%-10s : %s\n", 'ERROR', message if @stdout
    end

    def info(message)
      @file.printf "%-27s - %-10s : %s \n",
                    Time.now.to_s,
                    'INFORM',
                    message unless @file.nil?
      printf "%-10s : %s\n", 'INFORM', message if @stdout
    end

    def dump(data)
      @file.printf "%-27s - %-10s : \n", Time.now.to_s, 'DATA:'
      PP.pp(data, @file)
      @file.printf "\n"
      printf "%-10s : \n", 'DATA:'
      PP.pp(data)
      printf "\n"
    end
  end
end

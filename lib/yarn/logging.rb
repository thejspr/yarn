require 'logger'
require 'date'

module Yarn
  module Logging

    def log(msg)
      if msg.respond_to?(:each)
        msg.each do |line|
          output.puts "#{timestamp} #{line}"
        end
      else
        output.puts "#{timestamp} #{msg}"
      end
    end

    def debug(msg=nil)
      log "DEBUG: #{msg}" if $debug
    end

    def output
      $output || $stdout
    end

    def timestamp
      current_time = DateTime.now
      "#{current_time.strftime("%d/%m/%y %H:%M:%S")} -"
    end
  end
end

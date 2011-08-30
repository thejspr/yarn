require 'logger'
require 'date'

module Yarn
  module Logging

    def log(msg)
      output.puts "#{timestamp} #{msg}"
    end

    def debug(msg=nil)
      log "DEBUG: #{msg || yield}"
    end

    private

    def output
      $output || $stdout
    end

    def timestamp
      current_time = DateTime.now
      "#{current_time.strftime("%d/%m/%y %H:%M:%S")} -"
    end
  end
end

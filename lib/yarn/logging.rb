require 'date'

module Yarn
  # Enables logging messages to $output.
  module Logging

    # Logs a message to $output.
    # Doesnt do anything unless logging or debugging is enabled.
    def log(msg)
      return nil unless $log
      if msg.respond_to?(:each)
        msg.each do |line|
          output.puts "#{timestamp} #{line}"
        end
      else
        output.puts "#{timestamp} #{msg}"
      end
    end

    # Appends DEBUG to a log message.
    # Doesnt do anything if debugging is disabled.
    def debug(msg=nil)
      log "DEBUG: #{msg}" if $debug
    end

    # Proxy for the output variable.
    def output
      out ||= $output || $stdout
      out
    end

    # Returns a formattet timestamp.
    def timestamp
      current_time = DateTime.now
      "#{current_time.strftime("%d/%m/%y %H:%M:%S")} -"
    end
  end
end

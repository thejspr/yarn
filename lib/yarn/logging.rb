require 'logger'

module Yarn
  module Logging

    def init_logger(debug=false)
      @logger = Logger.new(STDOUT)
      @logger.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%H:%M:%S")} - #{severity}: #{msg}\n"
      }
      @logger.level = Logger::DEBUG if debug
    end

    def log
      @logger
    end
  end
end

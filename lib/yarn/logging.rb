require 'logger'

module Yarn
  module Logging
# 
#     def logger
#       if @logger
#         @logger
#       else
#         @logger = Logger.new(output)
#         @logger.formatter = proc { |severity, datetime, progname, msg|
#           "#{datetime.strftime("%H:%M:%S")} - #{severity}: #{msg}\n"
#         }
#         @logger.level = Logger::DEBUG if debug
#         @logger
#       end
#     end

    def log(msg)
      puts msg
    end

    def debug(msg=nil)
      log msg || yield
    end
  end
end

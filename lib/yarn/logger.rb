module Yarn
  module Logger

    def log(message)
      @output.puts message.strip
    end
    module_function :log 
    public :log

    def debug(message=nil)
      if @debugging
        @output.puts "debug: " + (message.strip || yield)
      end
    end
    module_function :debug 
    public :debug

  end
end

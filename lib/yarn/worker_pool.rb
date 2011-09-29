require 'thread'

module Yarn
  class WorkerPool

    include Logging

    attr_reader :size, :app, :workers, :jobs

    def initialize(size=1024,app=nil)
      @size = size
      @app = app
      @jobs = Queue.new
      init_workers
    end

    def init_workers
      @workers = Array.new(@size) do
        Thread.new do
          Thread.current[:handler] = determine_handler
          Thread.stop
          loop do
            Thread.current[:handler].run @jobs.pop
          end
        end
      end
    end

    def determine_handler
      @handler ||= @app ? RackHandler.new(@app) : RequestHandler.new
    end

    def listen!
      @workers.each { |w| w.run }
    end

    def schedule(session)
      @jobs << session
    end

  end
end

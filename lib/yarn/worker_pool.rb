require 'thread'

module Yarn
  class WorkerPool

    include Logging

    attr_reader :size, :workers, :jobs

    def initialize(size=1024)
      @size = size
      @jobs = Queue.new
      init_workers
    end

    def init_workers
      @workers = Array.new(@size) do
        Thread.new do
          Thread.current[:handler] = RequestHandler.new
          Thread.stop
          loop do
            Thread.current[:handler].run @jobs.pop
          end
        end
      end
    end

    def listen!
      @workers.each { |w| w.run }
    end

    def schedule(session)
      @jobs << session
    end

  end
end

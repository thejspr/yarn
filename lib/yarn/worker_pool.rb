require 'yarn/worker'
require 'yarn/request_handler'
require 'yarn/logging'

require 'thread'

module Yarn
  class WorkerPool

    include Logging

    attr_reader :size, :workers

    def initialize(size=1024)
      @size = size
      @workers = create_pool
      @jobs = Queue.new
    end

    def create_pool
      return Array.new(@size) do
        Thread.new do
          loop do
            job = @jobs.pop
            job.call
          end
        end
      end
    end

    def schedule(&block)
      @jobs << block
    end

  end
end

# require 'celluloid'

module Yarn
  class Worker

    # include Celluloid

    attr_reader :handler

    def initialize(handler)
      @handler = handler
    end

    def process(session)
      @handler.run session
    end

  end
end

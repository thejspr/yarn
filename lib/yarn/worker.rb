require 'celluloid'

module Yarn
  class Worker

    include Celluloid

    def initialize(&block)
      block.call
    end

  end
end

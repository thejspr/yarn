require 'rack'

module Yarn
  class RackHandler < RequestHandler

    def initialize
      super
    end

    def prepare_response
      log @request
      @response 
    end

  end
end

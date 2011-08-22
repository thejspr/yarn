module Yarn
  class RequestHandler

    attr_accessor :parser, :request, :session

    def initialize(session)
      @session = session
      @parser = Parser.new
    end

    def run
      parse_request
      prepare_response
      return_response
      close_connection
    end

    def parse_request(request)
      @request = @parser.parse request
    end

    def prepare_response
    end

    def return_response
    end

    def close_connection
      @session.close
    end

  end
end

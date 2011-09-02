require 'yarn/parslet_parser'
require 'yarn/version'
require 'yarn/statuses'
require 'yarn/logging'
require 'date'
require 'rubygems'
require 'parslet'

module Yarn
  class RequestHandler

    include Logging

    attr_accessor :session, :parser, :request, :response

    def initialize
      @parser = ParsletParser.new
      @response = [ nil, {}, [] ] # [ status, headers, body ]

      set_common_headers
    end

    def run(session)
      @session = session
      if parse_request
        prepare_response
        return_response
      else
        raise Exception
      end

      close_connection
    end

    def parse_request
      begin
        request = read_request
        return false if request.empty?
        @request = @parser.run request
        # log "#{@request[:method]} #{@request[:path]} HTTP/#{@request[:version]}" 
        true
      rescue Parslet::ParseFailed => e
        @response[0] = 400
        debug "Parse failed: #{@request}"
        false
      end
    end

    def prepare_response
    end

    def return_response
      @session.puts "HTTP/1.1 #{@response[0]} #{HTTP_STATUS_CODES[@response[0]]}"

      @response[1].each do |key,value|
        @session.puts "#{key}: #{value}"
      end

      @session.puts ""

      @response[2].each do |line|
        @session.puts line
      end
      debug "Sent #{@response[1].size} headers"
    end

    def close_connection
      if @session #&& !persistent?
        @session.close
      else
        # TODO: start some kind of timeout
      end
    end

    def read_request
      input = []
      while (line = @session.gets) do
        break if line.length <= 2
        input << line
      end
      debug input.join
      input.join
    end

    def persistent?
      return @request[:headers]["Connection"] == "keep-alive"
    end

    def set_common_headers
      @response[1][:Server] = "Yarn webserver v#{VERSION}"

      # HTTP date format: Fri, 31 Dec 1999 23:59:59 GMT
      time = DateTime.now.new_offset(0)
      @response[1][:Date] = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      # Close connection header ( until support for persistent connections )
      # @response[1][:Connection] = "Close"
    end

  end
end

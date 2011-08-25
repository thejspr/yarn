require 'yarn/parser'
require 'yarn/version'
require 'yarn/statuses'
require 'yarn/logging'
require 'date'
require 'rubygems'
require 'parslet'

module Yarn
  class RequestHandler

    include Logging

    attr_accessor :parser, :request, :session, :response

    def initialize(session)
      init_logger

      @session = session
      @parser = Parser.new
      @response = [ nil, {}, [] ] # [ status, headers, body ]

      set_common_headers
    end

    def run
      if parse_request
        prepare_response
      end

      return_response
      close_connection
    end

    def parse_request
      begin
        @request = @parser.parse @session.gets
        true
      rescue Parslet::ParseFailed => e
        @response[0] = 400
        false
      end
    end

    def prepare_response
    end

    # def set_content_length
    #   unless @response[1]["Content-Length"]
    #     content_length = 0
    #     @response[2].each do |line|
    #       content_length += line.size
    #     end
    #     @response[1]["Content-Length"] = content_length
    #   end
    # end

    def return_response
      @session.puts "HTTP/1.1 #{@response[0]} #{HTTP_STATUS_CODES[@response[0]]}"

      @response[1].each do |key,value|
        @session.puts "#{key}: #{value}"
      end

      @session.puts " " # header/body divide

      @response[2].each do |line|
        @session.puts line
      end
    end

    def close_connection
      @session.close if @session && !persistent?
    end

    def persistent?
      @request[:headers].each do |header|
        if header[:name] == "Connection"
         return header[:value] == "keep-alive"
        end
      end

      false
    end

    def set_common_headers
      @response[1][:Server] = "Yarn webserver v#{VERSION}"

      # HTTP date format: Fri, 31 Dec 1999 23:59:59 GMT
      time = DateTime.now.new_offset(0)
      @response[1][:Date] = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      # Close connection header ( until support for persistent connections )
      @response[1][:Connection] = "Close"
    end

  end
end

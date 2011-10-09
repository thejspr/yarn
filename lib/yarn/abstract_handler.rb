require 'date'
require 'rubygems'
require 'parslet'

module Yarn

  class EmptyRequestError < StandardError; end
  class ProcessingError < StandardError; end

  class AbstractHandler

    include Logging
    include ErrorPage

    attr_accessor :session, :parser, :request, :response

    def initialize
      @parser = Parser.new
      @response = Response.new
    end

    def run(session)
      set_common_headers
      @session = session
      begin
        parse_request
        debug "Request parsed, path: #{request_path}"
        prepare_response
        debug "Response prepared: #{@response.status}"
        return_response
        log "#{STATUS_CODES[@response.status]} #{client_address} #{request_path}"
      rescue EmptyRequestError
        log "Empty request from #{client_address}"
      ensure
        @session.close
        debug "Connection closed"
      end
    end

    def parse_request
      raw_request = read_request
      raise EmptyRequestError if raw_request.empty?

      begin
        @request = @parser.run raw_request
      rescue Parslet::ParseFailed => e
        @response.status = 400
        debug "Parse failed: #{@request}"
      end
    end

    def prepare_response
    end

    def return_response
      @session.puts "HTTP/1.1 #{@response.status} #{STATUS_CODES[@response.status]}"
      @session.puts @response.headers.map { |k,v| "#{k}: #{v}" }
      @session.puts ""

      @response.body.each do |line|
        @session.puts line
      end
    end

    def read_request
      input = []
      while (line = @session.gets) do
        length = line.gsub(/\D/,"") if line =~ /Content-Length/
          if line == "\r\n"
            input << line
            input << @session.read(length.to_i) if length
            break
          else
            input << line
          end
      end

      debug "Done reading request"
      input.join
    end

    def persistent?
      return @request[:headers]["Connection"] == "keep-alive"
    end

    def set_common_headers
      @response.headers[:Server] = "Yarn webserver v#{VERSION}"

      # HTTP date format: Fri, 31 Dec 1999 23:59:59 GMT
      time ||= DateTime.now.new_offset(0)
      @response.headers[:Date] = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      # Close connection header ( until support for persistent connections )
      @response.headers[:Connection] = "Close"
    end

    def extract_path
      path = @request[:uri][:path].to_s
      if path[0] == "/" && path != "/"
        path = path[1..-1] 
      end
      path.gsub(/%20/, " ").strip
    end

    def post_body
      @request ? @request[:body].to_s : ""
    end

    def request_path
      @request[:uri][:path] if @request
    end

    def client_address
      @session.peeraddr(:numeric)[2] if @session
    end
  end
end

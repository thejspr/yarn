require 'date'
require 'rubygems'
require 'parslet'

module Yarn

  # Error for empty requests.
  class EmptyRequestError < StandardError; end
  # Error if parsing the request fails.
  class ProcessingError < StandardError; end

  # Base class for the handler classes.
  # Built using the Template Method design pattern.
  class AbstractHandler

    include Logging
    include ErrorPage

    attr_accessor :session, :parser, :request, :response

    def initialize
      @parser = Parser.new
      @response = Response.new
    end

    # The template method which drives the handlers.
    # Starts by setting common headers and parses the request,
    # prepares the response, returns it to the client, and closes
    # the connection.
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

    # Invokes the parser upon the request
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

    # Only implemented in the actual handler classes.
    def prepare_response
    end

    # returns the reqponse by writing it to the socket.
    def return_response
      begin
        @session.puts "HTTP/1.1 #{@response.status} #{STATUS_CODES[@response.status]}"
        @session.puts @response.headers.map { |k,v| "#{k}: #{v}" }
        @session.puts ""

        @response.body.each do |line|
          @session.puts line
        end
      rescue Exception => exception
        log "An error occured returning the response to the client"
      end
    end

    # Reads the request from the socket.
    # If a Content-Length header is given, that means there is an accompanying
    # request body. The body is read according to the set Content-Length.
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

    # Sets common headers like server name and date.
    def set_common_headers
      @response.headers[:Server] = "Yarn webserver v#{VERSION}"

      # HTTP date format: Fri, 31 Dec 1999 23:59:59 GMT
      time ||= DateTime.now.new_offset(0)
      @response.headers[:Date] = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      # Close connection header ( until support for persistent connections )
      @response.headers[:Connection] = "Close"
    end

    # Extracts the path from the parsed request
    def extract_path
      path = @request[:uri][:path].to_s
      if path[0] == "/" && path != "/"
        path = path[1..-1] 
      end
      path.gsub(/%20/, " ").strip
    end

    # Proxy to getting the request body.
    def post_body
      @request ? @request[:body].to_s : ""
    end

    # Proxy for getting the request path.
    def request_path
      @request[:uri][:path] if @request
    end

    # Proxy for the clients address.
    def client_address
      begin
        @session.peeraddr(:numeric)[2] if @session
      rescue Errno::ENOTCONN
        return ""
      end
    end
  end
end

require 'yarn/parslet_parser'
require 'yarn/version'
require 'yarn/statuses'
require 'yarn/logging'
require 'yarn/error_page'
require 'date'
require 'rubygems'
require 'parslet'

module Yarn

  class EmptyRequestError < StandardError; end

  class RequestHandler

    include Logging
    include ErrorPage

    attr_accessor :session, :parser, :request, :response

    def initialize
      @parser = ParsletParser.new
      @response = [ nil, {}, [] ] # [ status, headers, body ]

      set_common_headers
    end

    def run(session)
      @session = session
      begin
        parse_request
        prepare_response
        return_response
        log "Served #{client_address} #{request_path}"
      rescue EmptyRequestError
        log "Empty request from #{client_address}"
      ensure
        close_connection
      end
    end

    def parse_request
      raw_request = read_request
      raise EmptyRequestError if raw_request.empty?

      begin
        @request = @parser.run raw_request
      rescue Parslet::ParseFailed => e
        @response[0] = 400
        debug "Parse failed: #{@request}"
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

    def serve_file(path)
      @response[0] = 200
      @response[2] << read_file(path)
      @response[1]["Content-Type"] = get_mime_type path
    end

    def serve_directory(path)
      @response[0] = 200
      if File.exists?("index.html") || File.exists?("/index.html")
        @response[2] = read_file "index.html"
        @response[1]["Content-Type"] = "text/html"
      else
        @response[1]["Content-Type"] = "text/html"
        directory_lister = DirectoryLister.new
        @response[2] << directory_lister.list(path)
      end
    end

    def read_file(path)
      file_contents = []

      File.open(path, "r") do |file|
        while (line = file.gets) do
          file_contents << line
        end
      end

      file_contents
    end

    def extract_path
      path = @request[:uri][:path].to_s
      if path[0] == "/" && path != "/"
        path = path[1..-1] 
      end
      path.gsub(/%20/, " ").strip
    end

    def serve_directory(path)
      @response[0] = 200
      if File.exists?("index.html")# || File.exists?("/index.html")
        @response[2] = read_file "index.html"
        @response[1]["Content-Type"] = "text/html"
      else
        @response[1]["Content-Type"] = "text/html"
        @response[2] << DirectoryLister.list(path)
      end
    end

    def request_path
      @request[:uri][:path] if @request
    end
    
    def client_address
      @session.peeraddr(:numeric)[2] if @session
    end
  end
end

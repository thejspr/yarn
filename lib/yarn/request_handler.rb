require 'date'
require 'rubygems'
require 'parslet'

module Yarn

  class EmptyRequestError < StandardError; end
  class ProcessingError < StandardError; end

  class RequestHandler

    include Logging
    include ErrorPage

    attr_accessor :session, :parser, :request, :response

    def initialize
      @parser = ParsletParser.new
      @response = Response.new
    end

    def run(session)
      @response = Response.new
      set_common_headers
      @session = session
      begin
        parse_request
        prepare_response
        return_response
        log "#{STATUS_CODES[@response.status]} #{client_address} #{request_path}"
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
        @response.status = 400
        debug "Parse failed: #{@request}"
      end
    end

    def prepare_response
      path = extract_path

      @response.headers["Content-Type"] = "text/html"

      begin
        if File.directory? path
          serve_directory path
        elsif File.exists?(path)
          if path =~ /.*\.rb$/
            @response.body << execute_script(path)
            @response.status = 200
          else
            serve_file(path)
          end
        else
          serve_404_page
        end
      rescue ProcessingError
        log "An error occured processing #{path}"
        serve_500_page
      end
    end

    def execute_script(path)
      response = `ruby #{path}`
      if !! ($?.to_s =~ /1$/)
        raise ProcessingError
      else
        response
      end
    end

    def return_response
      @session.puts "HTTP/1.1 #{@response.status} #{STATUS_CODES[@response.status]}"
      @session.puts @response.headers.map { |k,v| "#{k}: #{v}" }
      @session.puts ""

      @response.body.each do |line|
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
      @response.headers[:Server] = "Yarn webserver v#{VERSION}"

      # HTTP date format: Fri, 31 Dec 1999 23:59:59 GMT
      time = DateTime.now.new_offset(0)
      @response.headers[:Date] = time.strftime("%a, %d %b %Y %H:%M:%S GMT")
      # Close connection header ( until support for persistent connections )
      @response.headers[:Connection] = "Close"
    end

    def serve_file(path)
      @response.status = 200
      @response.body << read_file(path)
      @response.headers["Content-Type"] = get_mime_type path
    end

    def serve_directory(path)
      @response.status = 200
      if File.exists?("index.html") || File.exists?("/index.html")
        @response.body = read_file "index.html"
        @response.headers["Content-Type"] = "text/html"
      else
        @response.headers["Content-Type"] = "text/html"
        directory_lister = DirectoryLister.new
        @response.body << directory_lister.list(path)
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
      @response.status = 200
      if File.exists?("index.html")# || File.exists?("/index.html")
        @response.body = read_file "index.html"
        @response.headers["Content-Type"] = "text/html"
      else
        @response.headers["Content-Type"] = "text/html"
        @response.body << DirectoryLister.list(path)
      end
    end

    def get_mime_type(path)
      return false unless path.include? '.'
      filetype = path.split('.').last

      return case
    when ["html", "htm"].include?(filetype)
      "text/html"
    when "txt" == filetype 
      "text/plain"
    when "css" == filetype
      "text/css"
    when "js" == filetype
      "text/javascript"
    when ["png", "jpg", "jpeg", "gif", "tiff"].include?(filetype)
      "image/#{filetype}"
    when ["zip","pdf","postscript","x-tar","x-dvi"].include?(filetype)
      "application/#{filetype}"
    else false
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

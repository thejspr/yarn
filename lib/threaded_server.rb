require "threaded_server/version"

require 'socket'
require 'http_parser'

module ThreadedServer
  class Server

    attr_accessor :host, :port, :socket

    def initialize(output,test=false)
      @output = output
    end

    def start(host='localhost',port=8000)
      begin
        @host, @post = host, port
        @socket = TCPServer.new(host, port)

        @output.puts "Server started on port #{port}"

        start_request_listener
      rescue Exception => e
        @output.puts "An error occured starting ThreadedServer: #{e.message}"
        exit
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      @output.puts "Server stopped"
    end

    def start_request_listener
      while( session = @socket.accept ) do
        puts session.gets
        session.puts HTTPParser.parse_request(session.gets) 
        session.close
      end
    end

  end
end

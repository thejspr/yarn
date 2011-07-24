require "threaded_server/version"
require "threaded_server/logger"

require 'socket'

module ThreadedServer
  class Server

    include Logger

    attr_accessor :host, :port, :socket, :output

    def initialize(output)
      @output = output
    end

    def start(host='localhost',port=8000)
      begin
        @host, @port = host, port
        @socket = TCPServer.new(@host, @port)

        log "Server started on port #{port}"

        while( session = @socket.accept ) do
          Thread.new do 
            log session.gets
            body = File.new('index.html').read
            
            session.puts "HTTP/1.1 200 OK"
            session.puts "\r\n"
            session.puts body

            session.close
          end
        end
      rescue Exception => e
        log "An error occured starting ThreadedServer: #{e.message}"
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log "Server stopped"
    end

  end
end

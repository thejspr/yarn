require "yarn/version"
require "yarn/logger"
require "yarn/parser"

require 'socket'

module Yarn
  class Server

    include Logger

    attr_accessor :host, :port, :socket, :output, :debugging

    def initialize(output)
      @output = output
    end

    def start(host,port,debugging)
      begin
        @host, @port, @debugging = host, port, debugging
        @socket = TCPServer.new(@host, @port)

        log "Server started on port #{@port}"

        while( session = @socket.accept ) do
          Thread.new do 
            log session.gets
            # request = Parser.parse(session)
            body = File.new('index.html').read
            log "Served: index.html"
            
            session.puts "HTTP/1.1 200 OK"
            session.puts "\r\n"
            session.puts body

            session.close
          end
        end
      rescue Exception => e
        log "An error occured starting Yarn: #{e.message}"
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log "Server stopped"
    end

  end
end

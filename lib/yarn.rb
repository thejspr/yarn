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
      
      @host, @port, @debugging = host, port, debugging

      begin
        @socket = TCPServer.new(@host, @port)

        log "Server started on port #{@port}"

        while( session = @socket.accept ) do

          session.close
        end

      rescue Exception => e
        log "An error occured: #{e.message}"
      ensure
        self.stop
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log "Server stopped"
    end

  end
end

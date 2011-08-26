require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"
require "yarn/logging"

require 'socket'

module Yarn

  class Server

    include Logging

    attr_accessor :host, :port, :socket

    def initialize(host,port)
      @host = host
      @port = port
    end

    def start
      @socket = TCPServer.new(@host, @port)

      log "Yarn started and accepting requests on #{@host}:#{@port}"

      begin
        while( session = @socket.accept ) do
          handler = StaticHandler.new session
          handler.run
        end
      rescue Interrupt => e
        log "Server interrupted, stopping..."
      ensure
        stop
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log "Server stopped"
    end

  end
end

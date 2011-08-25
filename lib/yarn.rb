require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"
require "yarn/logging"

require 'socket'

module Yarn

  class Server

    include Logging

    attr_accessor :host, :port, :socket

    def initialize(host,port,debug)
      @host = host
      @port = port

      init_logger(debug)
    end

    def start
      @socket = TCPServer.new(@host, @port)

      log.info "Yarn started and accepting requests on #{@host}:#{@port}"

      while( session = @socket.accept ) do
        handler = StaticHandler.new(session)
        handler.run
      end
      stop
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log.info "Server stopped"
    end

  end
end

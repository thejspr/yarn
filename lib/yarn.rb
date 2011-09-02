require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"
require "yarn/logging"

require 'socket'

module Yarn

  class Server

    include Logging

    attr_accessor :host, :port, :socket

    def initialize(host,port,output=$stdout)
      @host = host
      @port = port
      $output = output
    end

    def start
      @socket = TCPServer.new(@host, @port)

      log "Yarn started and accepting requests on #{@host}:#{@port}"

      # handlers = []
      # 10.times do
      #   handlers << StaticHandler.new
      # end

      begin
        while( session = @socket.accept ) do
          begin
          handler = StaticHandler.new
          handler.run session
          rescue Exception => e
            log e.message
            log e.backtrace
            session.close
          end
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

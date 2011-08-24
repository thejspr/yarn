require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"

require 'socket'
require 'logger'

module Yarn

  class Server

    attr_accessor :host, :port, :socket, :log

    def initialize(host,port,debug)
      @host = host
      @port = port

      @log = Logger.new(STDOUT)
      @log.formatter = proc { |severity, datetime, progname, msg|
        "#{datetime.strftime("%H:%M:%S")} - #{severity}: #{msg}\n"
      }
      @log.level = Logger::DEBUG if debug
    end

    def start
      @socket = TCPServer.new(@host, @port)

      @log.info "Yarn started and accepting requests on #{@host}:#{@port}"

      while( session = @socket.accept ) do
        handler = StaticHandler.new(session)
        handler.run
      end
      stop
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      @log.info "Server stopped"
    end

  end
end

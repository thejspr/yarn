require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"
require "yarn/logging"

require 'socket'

module Yarn

  class Server

    include Logging

    attr_accessor :host, :port, :socket

    def initialize(options={})
      options = { output: $stdout, host: '127.0.0.1', :port => 3000 }.merge(options)
      @host = options[:host]
      @port = options[:port]
      $output = options[:output]
    end

    def start
      @socket = TCPServer.new(@host, @port)

      log "Yarn started and accepting requests on #{@host}:#{@port}"

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
        log "Caught interrupt, stopping..."
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

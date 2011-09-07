require "yarn/version"
require "yarn/request_handler"
require "yarn/static_handler"
require "yarn/dynamic_handler"
require 'yarn/worker_pool'
require "yarn/logging"

require 'socket'

module Yarn

  class Server

    include Logging

    attr_accessor :host, :port, :socket, :socket_listener, :handler

    def initialize(options={})
      # merge given options with default values
      options = { 
        handler: :static,
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000, 
        pool_size: 5 
      }.merge(options)

      $output = options[:output]
      @host = options[:host]
      @port = options[:port]
      @handler = set_handler(options[:handler])
      @socket = TCPServer.new(@host, @port)

      log "Yarn started as #{options[:handler]} and accepting requests on #{@host}:#{@port}"
    end

    def start
      @socket_listener = Thread.new do
        loop do
          begin
            session = @socket.accept
            Thread.new { @handler.new.run session }
          rescue Exception => e
            session.close
            log e.message
            log e.backtrace
          end
        end
      end

      begin
        @socket_listener.join
      rescue Interrupt => e
        log "Caught interrupt, stopping..."
      ensure
        stop
      end
    end

    def stop
      @socket.close if @socket
      @socket = nil
      @socket_listener.kill if @socket_listener

      log "Server stopped"
    end

    def set_handler(handler_symbol)
      handler =  case handler_symbol
                 when :static then StaticHandler
                 when :dynamic then DynamicHandler
                 else
                   raise Exception
                 end
    end

  end
end

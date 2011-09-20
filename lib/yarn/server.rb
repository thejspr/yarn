require 'socket'

module Yarn
  class Server

    include Logging

    attr_accessor :host, :port, :socket, :socket_listener

    def initialize(app=nil,opts={})
      # merge given options with default values
      options = { 
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000 
      }.merge(opts)

      @app = app
      @host,@port,$output = options[:host], options[:port], options[:output]

      @socket = TCPServer.new(@host, @port)

      @handler = @app ? RackHandler.new(@app, options) : RequestHandler.new(options)

      log "Yarn started #{"w/ Rack " if opts[:rackup_file]}and accepting requests on #{@host}:#{@port}"
    end

    def start
      @socket_listener = Thread.new do
        loop do
          begin
            session = @socket.accept
            Thread.new { @handler.clone.run session }
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
  end
end

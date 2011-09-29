require 'socket'

module Yarn
  class Server

    include Logging

    attr_accessor :host, :port, :socket, :socket_listener, :worker_pool

    def initialize(app=nil,opts={})
      # merge given options with default values
      options = { 
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000,
        workers: 32 
      }.merge(opts)

      @app = app
      @host,@port,$output = options[:host], options[:port], options[:output]
      @socket = TCPServer.new(@host, @port)
      @worker_pool = WorkerPool.new(options[:workers], @app)
      create_listener
    end

    def create_listener
      @socket_listener = Thread.new do
        loop do
          begin
            # waits here until a requests comes in
            session = @socket.accept
            debug "Accepted request"
            # Thread.new { (@app ? RackHandler.new(@app) : RequestHandler.new).run session }
            @worker_pool.schedule session
          rescue Exception => e
            session.close
            log e.message
            log e.backtrace
          end
        end
      end
    end

    def start
      log "Yarn started and accepting requests on #{@host}:#{@port}"
      begin
        @worker_pool.listen!
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

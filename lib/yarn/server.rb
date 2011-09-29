require 'socket'

module Yarn
  class Server

    include Logging

    attr_accessor :host, :port, :socket, :socket_listener, :worker_pool

    def initialize(app=nil,options={})
      # merge given options with default values
      opts = { 
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000,
        workers: 32 
      }.merge(options)

      @app = app
      @host, @port = opts[:host], opts[:port]
      $output, $debug = opts[:output], opts[:debug]
      @socket = TCPServer.new(@host, @port)
      @worker_pool = WorkerPool.new(opts[:workers], @app)
      create_listener
    end

    def create_listener
      @threads = []
      @counter = 0
      @socket_listener = Thread.new do
        loop do
          begin
            # waits here until a requests comes in
            session = @socket.accept
            @threads << Thread.new { 
              (@app ? RackHandler.new(@app) : RequestHandler.new).run session 
            }
            @counter += 1
            if @counter % 10 == 0
              debug "Thread count: #{@threads.size}"
            end
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
      debug "Served #{@counter} requests"
      debug "#{@threads.collect { |t| t.alive? }.size} live threads"
    end
  end
end

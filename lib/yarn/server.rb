require 'socket'

module Yarn
  class Server

    include Logging

    attr_accessor :host, :port, :socket

    def initialize(app=nil,options={})
      # merge given options with default values
      opts = { 
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000,
        workers: 4 
      }.merge(options)

      @app = app
      @host, @port, @num_workers = opts[:host], opts[:port], opts[:workers]
      $output, $debug = opts[:output], opts[:debug]
      @socket = TCPServer.new(@host, @port)
    end

    def start
      log "Yarn started #{@num_workers} workers and is listening on #{@host}:#{@port}"

      @num_workers.times do
        fork do
          trap("INT") { exit }
          loop do
            handler ||= @app ? RackHandler.new(@app) : RequestHandler.new
            session = @socket.accept
            handler.run session 
          end
        end
      end

      # Waits here for all processes to exit
      Process.waitall
      stop
    end

    def stop
      @socket.close unless @socket.closed?

      log "Server stopped. Have a nice day!"
    end
  end
end

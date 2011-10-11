require 'socket'

module Yarn
  class Server

    include Logging
    include Socket::Constants
    
    # TCP optimizations
    TCP_OPTS = [ 
      # delays accepting connections until clients send data
      [Socket::SOL_TCP, TCP_DEFER_ACCEPT, 1],
      # send ACK flags in their own packets (faster)
      [Socket::SOL_TCP, TCP_QUICKACK, 1],
      # set maximum number of
    ]

    attr_accessor :host, :port, :socket, :workers

    def initialize(options={})
      # merge given options with default values
      opts = { 
        output: $stdout, 
        host: '127.0.0.1', 
        port: 3000,
        workers: 4,
        log: true,
        rack: "off" 
      }.merge(options)

      @app = nil
      @app = load_rack_app(opts[:rack]) unless opts[:rack] == "off"
      @opts = opts

      @host, @port, @num_workers = opts[:host], opts[:port], opts[:workers]
      @workers = []
      $output, $debug = opts[:output], opts[:debug]
      $log = opts[:log] || opts[:debug]
    end

    def load_rack_app(app_path)
      if File.exists?(app_path)
        config_file = File.read(app_path)
        rack_application = eval("Rack::Builder.new { #{config_file} }")
      else
        log "#{app_path} does not exist. Exiting."
        Kernel::exit
      end
    end

    def start
      trap("INT") { stop }
      @socket = TCPServer.new(@host, @port)
      @socket.listen(1024)
      ::BasicSocket.do_not_reverse_lookup=true
      log "Yarn started #{@num_workers} workers and is listening on #{@host}:#{@port}"

      init_workers

      # Waits here for all processes to exit
      Process.waitall
    end

    def configure_socket
      TCP_OPTS.each do |opt|
        @session.setsockopt(*opt)
      end
    end

    def init_workers
      [ @num_workers-1, 1 ].max.times do
        @workers << fork_worker
      end
    end

    def fork_worker
      fork { worker }
    end

    def worker
      trap("INT") { exit }
      loop do
        @handler ||= @app ? RackHandler.new(@app,@opts) : RequestHandler.new
        @session = @socket.accept
        configure_socket
        @handler.run @session
      end
    end

    def stop
      @socket.close if (@socket && !@socket.closed?)

      log "Server stopped. Have a nice day!"
    end
  end
end

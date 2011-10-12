require 'socket'

# Yarn namespace
module Yarn
  # The heart of Yarn which starts a TCP server and forks workers which handles requests.
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

    # Initializes a new Server with the given options Hash.
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

      @app = opts[:rack] == "off" ? nil : load_rack_app(opts[:rack])
      @opts = opts

      @host, @port, @num_workers = opts[:host], opts[:port], opts[:workers]
      @workers = []
      $output, $debug = opts[:output], opts[:debug]
      $log = opts[:log] || opts[:debug]
    end

    # Loads a Rack application from a given file path.
    # If the file does not exist, the program exits.
    def load_rack_app(app_path)
      if File.exists?(app_path)
        config_file = File.read(app_path)
        rack_application = eval("Rack::Builder.new { #{config_file} }.to_app", TOPLEVEL_BINDING, app_path)
      else
        log "#{app_path} does not exist. Exiting."
        Kernel::exit
      end
    end

    # Creates a new TCPServer and invokes init_workers
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

    # Applies TCP optimizations to the TCP socket
    def configure_socket
      TCP_OPTS.each { |opt| @session.setsockopt(*opt) }
    end

    # Runs fork_worker @num_worker times
    def init_workers
      @num_workers.times { @workers << fork_worker }
    end

    # Forks a new process with a worker
    def fork_worker
      fork { worker }
    end

    # Contains the logic performed by each worker.  It first determines the
    # handler type and then start an infinite loop listening for incomming
    # requests. Upon receiving a request, it fires the run method on the handler.
    def worker
      trap("INT") { exit }
      handler = get_handler
      loop do
        @session = @socket.accept
        configure_socket
        handler.run @session
      end
    end

    # Returns the handler corresponding to whether a Rack application is present.
    def get_handler
      @app ? RackHandler.new(@app,@opts) : RequestHandler.new
    end

    # Closes the TCPServer and exits with a message.
    def stop
      @socket.close if (@socket && !@socket.closed?)

      log "Server stopped. Have a nice day!"
    end
  end
end

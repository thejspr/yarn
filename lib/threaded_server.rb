require "threaded_server/version"
require "threaded_server/logger"

require 'socket'

module ThreadedServer
  class Server

    include Logger

    attr_accessor :host, :port, :socket, :output

    def initialize(output)
      @output = output
    end

    def start(host='localhost',port=8000)
      begin
        @host, @port = host, port
        @socket = TCPServer.new(@host, @port)

        log "Server started on port #{port}"

        start_request_listener
      rescue Exception => e
        log "An error occured starting ThreadedServer: #{e.message}"
      end
    end

    def stop
      @socket.close unless @socket.nil?
      @socket = nil

      log "Server stopped"
    end

    def start_request_listener
      while( session = @socket.accept ) do
        log session.gets
        write_response(session,nil,[],"Success!")
      end
    end

    def write_response(session,status,headers,body)
      write_status session, status
      write_headers session, headers
      write_body session, body
      
      session.close
    end

    def write_status(session,status)
      session.puts "HTTP/1.1 200 OK"
    end

    def write_headers(session,headers)
      headers.each do |header|
        session.puts header + "\r\n"
      end
    end

    def write_body(session,body)
      session.puts "\r\n"
      session.puts body
    end

  end
end

require 'uri'
require 'faraday'

module Helpers
  def send_data(data)
    socket = TCPSocket.new(@server.host, @server.port)
    socket.write data
    out = socket.read
    socket.close
    out
  end

  def get(url)
    setup
    @connection.get "test_objects#{url}"
  end

  def post(url, params={})
    setup
    @connection.post url
  end

  def stop_server
    @thread.kill if @thread
    @server.stop if @server
  end

  def start_server(port=3000,handler=:static)
    $console = MockIO.new
    @server = Yarn::Server.new({ port: port, output: $console, handler: handler })
    @thread = Thread.new { @server.start }
    sleep 0.1 until @server.socket # wait for socket to be created
  end
  
  def mock_request(filename="/")
    MockIO.new("GET #{filename} HTTP/1.1\n")
  end

  private

  def setup
    host = URI.parse("http://#{@server.host}:#{@server.port}")
    @connection ||= Faraday.new(host)
  end
end

class MockIO
  def initialize(content="")
    @contents ||= []
    @contents << content
  end

  def puts(string)
    @contents << string
  end

  def gets
    @contents.last
  end

  def contains?(string)
    @contents.each do |line|
      if line.include? string
        return true
      end
    end
    false
  end

  def include?(string)
    contains?(string)
  end
end


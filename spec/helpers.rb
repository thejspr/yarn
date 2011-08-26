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
    @connection.get "test_objects/#{url}"
  end
  
  def post(url, params={})
    setup
    @connection.post url
  end

  def stop_server
    @thread.kill
    @server.stop
  end

  def start_server(port=3000)
    @server = Yarn::Server.new('127.0.0.1', port)
    @thread = Thread.new { @server.start }
    sleep 0.1 until @server.socket # wait for socket to be created
  end

  private

  def setup
    host = URI.parse("http://#{@server.host}:#{@server.port}")
    @connection ||= Faraday.new(host)
  end

end

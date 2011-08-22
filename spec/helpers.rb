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
    uri = URI.parse("http://#{@server.host}:#{@server.port}")
    conn = Faraday.new(uri)
    conn.get url
  end
  
  def post(url, params={})
    uri = URI.parse("http://#{@server.host}:#{@server.port}" + url)
    # HTTPClient.post(uri, params).body
  end

  def stop_server
    @thread.kill
    @server.stop
  end

  def start_server(host='localhost',port=8000)
    @thread = Thread.new { @server.start(host,port,true) }
    sleep 0.1 until @server.socket # wait for socket to be created
  end
end


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
    if url == ""
      @connection.get "/"
    else
      @connection.get "test_objects#{url}"
    end
  end

  def post(url, data)
    setup
    @connection.post url, data
  end

  def stop_server
    @thread.kill if @thread
    @server.workers.each { |worker_id| Process.kill("INT", worker_id) } if @server and !@server.workers.empty?
    @server.stop if @server
    sleep 0.1 # enable socket to close before next test
  end

  def start_server(port=3000,rack="off")
    $console ||= MockIO.new
    @server = Yarn::Server.new({ port: port, output: $console, rack: rack, debug: true })
    @thread = Thread.new { @server.start }
    sleep 0.1 until @server.socket # wait for socket to be created
  end


  def testfile_exists?(filename)
    File.exists? File.join(File.join(File.dirname(__FILE__), "/../"), "test_objects/#{filename}")
  end

  def valid_html?(response)
    begin
      lambda { Nokogiri::HTML(response) { |config| config.strict } }
    rescue Nokogiri::HTML::SyntaxError
      false
    else
      true
    end
  end
  private

  def setup
    host = "127.0.0.1"
    port = "3000"
    uri = URI.parse("http://#{host}:#{port}")
    @connection = Faraday.new(uri)
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


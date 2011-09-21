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
    @connection.post url, params
  end

  def stop_server
    @thread.kill if @thread
    @server.stop if @server
    Process.kill("TERM",@rack_server) if @rack_server
  end

  def start_server(port=3000,opts={})
    $console ||= MockIO.new
    @server = Yarn::Server.new(nil,{ port: port, output: $console })
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


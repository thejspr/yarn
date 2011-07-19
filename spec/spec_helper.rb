require 'rubygems'
require 'bundler/setup'
require 'capybara/rspec'

require 'net/http'

require 'threaded_server'

module Helpers
  def send_data(data)
    socket = TCPSocket.new(@server.host, @server.port)
    socket.write data
    out = socket.read
    socket.close
    out
  end

  def get(url)
    Net::HTTP.get(URI.parse("http://#{@server.host}:#{@server.port}" + url))
  end
  
  def post(url, params={})
    Net::HTTP.post_form(URI.parse("http://#{@server.host}:#{@server.port}" + url), params).body
  end

  def stop_server
    @server.stop
    @thread.kill
  end

  def start_server(host='localhost',port=8000)
    @thread = Thread.new { @server.start(host,port) }
    sleep 0.1 until @server.socket # wait for socket to be created
  end
end

RSpec.configure do |config|
  config.include Helpers
end

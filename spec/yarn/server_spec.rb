require 'spec_helper'

module Yarn
  describe Server do

    before(:each) do
      $console = MockIO.new
    end

    after(:each) do
      stop_server
      @server.stop if @server
    end

    describe "#new" do
      it "should creates a TCP server" do
        @server = Server.new(nil, output: $console)
        @server.socket.class.should == TCPServer
      end

      it "should listen on the supplied port" do
        @server = Server.new(nil,{ port: 4000, output: $console })

        @server.socket.addr.should include(4000)
      end

      it "should create the worker pool" do
        @server = Server.new(nil,{ output: $console })
        @server.worker_pool.class.should == WorkerPool
        @server.worker_pool.jobs.size.should == 0
        @server.worker_pool.workers.size.should == 32
      end
    end

    describe "#create_listener" do
      it "should create a listener thread" do
        @server = Server.new(nil,{ output: $console })
        @server.socket_listener.alive?.should be_true 
      end
    end

    describe "#start" do
      it "should start the socket_listener" do
        @thread = Thread.new do
          @server = Server.new(nil,{ output: $console })
          @server.start
        end
        sleep 2
        get("/").should be_true
        @thread.kill
      end
    end

    describe "#stop" do
      it "should notify the server is stopped" do
        @server = Server.new(nil,{ output: $console })
        @server.stop

        $console.should include("Server stopped")
      end
    end

  end
end

require 'spec_helper'

module Yarn
  describe Server do

    after(:each) do
      stop_server
    end

    describe "#new" do
    end

    describe "#load_rack_app" do

      before(:each) do
        $console = MockIO.new
        @server = Server.new( output: $console )
      end

      it "should print a message and exit if the file does not exist" do
        Kernel.should_receive(:exit)
        @server.load_rack_app("non-existing-app.ru")
        $console.should include("non-existing-app.ru does not exist. Exiting.") 
      end

      it "should return a rack app if the file exists" do
        app = @server.load_rack_app("test_objects/config.ru")
        app.class.should == Rack::Builder
      end
    end

    describe "#start" do
      it "should creates a TCP server" do
        @server = Server.new
        @server.stub(:init_workers)
        @server.start

        @server.socket.class.should == TCPServer
      end

      it "should listen on the supplied port" do
        @server = Server.new({ port: 4000 })
        @server.stub(:init_workers)
        @server.start

        @server.socket.addr.should include(4000)
      end
    end

    # describe "#start" do
    #   it "should start the socket_listener" do
    #     @thread = Thread.new do
    #       @server = Server.new({ output: $console })
    #       @server.start
    #     end
    #     sleep 2
    #     get("/").should be_true
    #     @thread.kill
    #   end
    # end

    describe "#stop" do
      it "should notify the server is stopped" do
        $console = MockIO.new
        @server = Server.new({ output: $console })
        @server.stub(:init_workers)
        @server.start
        @server.stop

        $console.should include("Server stopped")
      end
    end

  end
end

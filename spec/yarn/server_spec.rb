require 'spec_helper'

module Yarn
  describe Server do

    after(:each) do
      stop_server
    end

    describe "#new" do
      it "should set the app if parameter is given" do
        @server = Server.new({ rack: "test_objects/config.ru" })

        @server.instance_variable_get("@app").should_not be_nil
      end
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
        app.class.should == Proc
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

    describe "#worker" do
      it "should start the handler" do
        # modify loop to only run once
        class Yarn::Server
          private
          def loop
            yield
          end
        end
        @server = Server.new
        @server.stub(:init_workers)
        @server.stub(:configure_socket)
        @server.socket.stub(:accept).and_return("GET / HTTP/1.1")

        RackHandler.any_instance.should_receive(:run)

        @server.worker
      end
    end

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

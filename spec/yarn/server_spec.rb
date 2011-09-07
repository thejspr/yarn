require 'spec_helper'

module Yarn
  describe Server do

    after(:each) do
      stop_server
    end

    describe "#new" do
      it "should set the handler type for static files" do
        server = Server.new(handler: :static)

        server.handler.class.should == StaticHandler.class
        server.stop
      end

      it "should set the handler type for dynamic files" do
        server = Server.new(handler: :dynamic)

        server.handler.class.should == DynamicHandler.class
        server.stop
      end
    end

    describe "#start" do
      it "creates a TCP server" do
        start_server
        @server.socket.should_not be_nil
      end

      it "starts on the supplied port" do
        start_server(4000)

        @server.socket.addr.should include(4000)
      end
    end

    describe "#stop" do
      it "notifies the server is stopped" do
        start_server
        @server.stop

        $console.should include("Server stopped")
      end
    end

  end
end

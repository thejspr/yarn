require 'spec_helper'

module Yarn
  describe Server do

    after(:each) do
      stop_server
    end

    describe "#start" do
      it "creates a TCP server" do
        start_server
        @server.socket.should_not be_nil
      end

      it "starts on the supplied port" do
        start_server(4000)
        puts @server.socket
        @server.socket.addr.should include(4000)
      end
    end

    describe "#stop" do
      it "notifies the server is stopped" do
        start_server
        @server.log.should_receive(:info).with('Server stopped')
      end
    end

  end
end

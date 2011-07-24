require 'spec_helper'

module ThreadedServer
  describe Server do

    before(:each) do
      @output = double('output').as_null_object
      @server = Server.new(@output)
    end 

    after(:each) do
      stop_server
    end

    describe "#start" do
      it "notifies the server is started" do
        @output.should_receive(:puts).with('Server started on port 8000')
        start_server
      end

      it "creates a TCP server" do
        start_server
        @server.socket.should_not be_nil
      end

      it "starts on the supplied port" do
        start_server('localhost',4000)
        @server.socket.addr.should include(4000)
      end
    end

    describe "#stop" do
      it "notifies the server is stopped" do
        start_server
        @output.should_receive(:puts).with('Server stopped')
      end
    end

  end
end

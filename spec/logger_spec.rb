require 'spec_helper'

module ThreadedServer
  describe Logger do
    before do
      @object = ThreadedServer::Server.new STDOUT
    end 

    describe "#log" do
      it "outputs message" do
        @object.output.should_receive(:puts)

        @object.log "test"
      end

      it "should be available as an instance method" do
        @object.should respond_to(:log)
      end
    end

    describe "#debug" do
      it "should be available as an instance method" do
        @object.should respond_to(:debug)
      end
    end
  end
end

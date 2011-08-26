require 'spec_helper'

module Yarn
  describe Logging do

    before(:each) do
      @server = Yarn::Server.new('127.0.0.1',3000)
    end

    describe "#log" do
      it "should make the logging methods available" do
        @server.should respond_to(:log)
        @server.should respond_to(:debug)
      end

      it "should be available in the handler classes" do
        @handler = RequestHandler.new nil

        @handler.should respond_to(:log)
        @handler.should respond_to(:debug)
      end
    end

  end
end

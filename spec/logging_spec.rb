require 'spec_helper'

module Yarn
  describe Logging do

    before(:each) do
      @server = Yarn::Server.new('127.0.0.1',3000,true)
    end

    describe "#log" do
      it "should make the logging methods available" do
        @server.log.should respond_to(:info)
        @server.log.should respond_to(:warn)
        @server.log.should respond_to(:debug)
      end

      it "should be available in the handler classes" do
        @handler = RequestHandler.new nil

        @handler.log.should respond_to(:info)
      end
    end

  end
end

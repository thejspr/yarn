require 'spec_helper'

module Yarn

  class TestLoggging
    include Logging
  end

  describe Logging do

    describe "#log" do
      it "should make the logging methods available" do
        @server = Server.new(output: $output)
        @server.should respond_to(:log)
        @server.should respond_to(:debug)
        @server.socket.close
      end

      it "should be available in the handler classes" do
        @handler = RequestHandler.new

        @handler.should respond_to(:log)
        @handler.should respond_to(:debug)
      end

      it "should send the message to output" do
        test_logger = TestLoggging.new
        test_logger.output.should_receive(:puts).once

        test_logger.log "testing"
      end

      it "should handles arrays" do
        test_logger = TestLoggging.new
        test_logger.output.should_receive(:puts).twice

        test_logger.log [1,2]
      end

    end

    describe "#debug" do
      it "should invoke the log method with a message" do
        test_logger = TestLoggging.new
        test_logger.should_receive(:log).with("DEBUG: testing").once

        test_logger.debug "testing"
      end
    end

  end
end

require 'spec_helper'

module Yarn
  describe RequestHandler do

    before(:each) do
      @dummy_request = "GET /resource/1 HTTP/1.1\r\nKeep-Alive: yes\r\n"
      @session = []
      @handler = RequestHandler.new @session
    end

    describe "#parse_request" do
      it "should invoke the Parser" do
        @handler.parser.should_receive(:parse)

        @handler.parse_request @dummy_request
      end

      it "should save the request hash" do
        @handler.request.should be_nil

        @handler.parse_request @dummy_request

        @handler.request.should_not be_nil
      end
    end

    describe "#close_connection" do
      it "should close the session connection" do
      end 
    end
  end
end

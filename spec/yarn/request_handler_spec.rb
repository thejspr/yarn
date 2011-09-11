require 'spec_helper'

module Yarn
  describe RequestHandler do

    before(:each) do
      @dummy_request = "GET /resource/1 HTTP/1.1\r\n "

      @session = mock('TCPSocket')
      @session.stub(:gets).and_return(@dummy_request)
      
      @handler = RequestHandler.new
      @handler.session = @session
      @handler.stub(:debug,:log).and_return(true) #silence output
      @handler.stub(:read_request).and_return(@dummy_request)
    end

    describe "#read_request" do
      it "should return a string from a feed" do
        @handler.unstub!(:read_request)
        @handler.session = StringIO.new
        @handler.session.string = "line1\nline2\nline3"

        @handler.read_request.should == "line1\nline2\nline3"
      end
    end

    describe "#parse_request" do
      it "should invoke the Parser" do
        @handler.parser.should_receive(:run)

        @handler.parse_request
      end

      it "should set the bad-request header if parsing fails" do
        bad_request = "BAD Warble warble request"
        @handler.response.status.should be_nil

        @session.stub(:gets).and_return(bad_request)
        @handler.parse_request

        @handler.response.status.should == 400
      end
    end

    describe "#return_response" do
      it "should write the response to the socket" do
        @handler.session.should_receive(:puts).at_least(1).times
        @handler.stub(:response).and_return("HTTP/1.1 201 OK")
        @handler.return_response
      end
    end

    describe "#persistent?" do
      it "should return true if the Connection header is set to keep-alive" do
        @handler.request = { headers: { "Connection" => "keep-alive" } }
        
        @handler.persistent?.should be_true
      end

      it "should return false if the Connection header is set to close" do
        @handler.request = { headers: { "Connection" => "close" } }

        @handler.persistent?.should be_false
      end
    end

    describe "#run" do
      it "should call all relevant template methods" do
        @handler.stub(:client_address)
        @handler.should_receive(:parse_request).once
        @handler.should_receive(:prepare_response).once
        @handler.should_receive(:return_response).once
        @handler.should_receive(:close_connection).once

        @handler.run(@dummy_request)
      end
    end
  end
end

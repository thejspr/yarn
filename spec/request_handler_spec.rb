require 'spec_helper'

module Yarn
  describe RequestHandler do

    before(:each) do
      @dummy_request = "GET /resource/1 HTTP/1.1\r\n"

      @session = mock('TCPSocket')
      @session.stub(:gets).and_return(@dummy_request)
      
      @handler = RequestHandler.new @session
      @handler.stub(:debug,:log).and_return(true) #silence output
    end

    describe "#initialize" do
      it "sets the base path" do
        @handler.basepath.should_not be_nil
      end
    end

    describe "#parse_request" do
      it "should invoke the Parser" do
        @handler.parser.should_receive(:parse)

        @handler.parse_request
      end

      it "should save the request hash" do
        @handler.request.should be_nil

        @handler.parse_request

        @handler.request.should_not be_nil
      end

      it "should set the bad-request header if parsing fails" do
        bad_request = "BAD Warble warble request"
        @handler.response[0].should be_nil

        @session.stub(:gets).and_return(bad_request)
        @handler.parse_request

        @handler.response[0].should == 400
      end
    end

    # describe "#set_content_length" do
    #   it "should set the Content-Length header if it's empty" do
    #     @handler.response[2] = ["four", "four", "four"]
    #     @handler.set_content_length
    #     @handler.response[1]["Content-Length"].should == 12
    #   end
    # end

    describe "#return_response" do
      it "should write the response to the socket" do
        @handler.session.should_receive(:puts).at_least(1).times
        @handler.stub(:response).and_return("HTTP/1.1 201 OK")
        @handler.return_response
      end
    end

    describe "#persistent?" do
      it "should return true if the Connection header is set to keep-alive" do
        @handler.parse_request
        @handler.request[:headers]["Connection"] = "keep-alive"
        
        @handler.persistent?.should be_true
      end

      it "should return false if the Connection header is set to close" do
        @handler.parse_request
        @handler.request[:headers]["Connection"] = "close"

        @handler.persistent?.should be_false
      end
    end

    # describe "#close_connection" do
    #   it "should close the session connection" do
    #     @handler.session.should_receive(:close)
    #     @handler.close_connection
    #   end 
    # end

  end
end

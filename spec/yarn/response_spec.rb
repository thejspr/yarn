require 'spec_helper'

module Yarn

  describe Response do
    before do
      @response = Response.new
    end

    describe "#status" do
      it "should is a HTTP status code" do
        @response.status = 404
        @response.status.should == 404
      end
    end

    describe "#headers" do
      it "should is a headers hash" do
        @response.headers = { "Connection" => "Close" }
        @response.headers["Connection"].should == "Close"
      end
    end

    describe "#body" do
      it "should be an array containing the response body" do
        @response.body << "Line 1" << "Line 2"
        @response.body.size.should == 2
        @response.body[0].should == "Line 1"
        @response.body[1].should == "Line 2"
      end
    end
  
  end
  
end


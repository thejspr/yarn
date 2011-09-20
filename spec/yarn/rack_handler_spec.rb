require 'spec_helper'

module Yarn
  describe RackHandler do

    describe "#prepare_response" do
    
    end

    describe "#make_env" do

      before(:each) do
        @handler = RackHandler.new(nil,{})
        @handler.request = @handler.parser.run "GET http://www.hostname.com:8888/some_controller/some_action?param1=1&param2=2 HTTP/1.1"
        @env = @handler.make_env
      end

      it "should set the REQUEST_METHOD" do
        @env["REQUEST_METHOD"].should == "GET"
      end

      it "should set the SCRIPT_NAME" do
        @env["SCRIPT_NAME"].should == ""
      end

      it "should set the PATH_INFO" do
        @env["PATH_INFO"].should == "/some_controller/some_action"
      end      

      it "should set the QUERY_STRING" do
        @env["QUERY_STRING"].should == "param1=1&param2=2"
      end

      it "should set the SERVER_NAME" do
        @env["SERVER_NAME"].should == "www.hostname.com"
      end

      it "should set the SERVER PORT" do
        @env["SERVER_PORT"].should == "8888"
      end
    end  
  end
end

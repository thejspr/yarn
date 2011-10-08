require 'spec_helper'

module Yarn
  describe RackHandler do

    before(:each) do
      @handler = RackHandler.new(nil,{ host: "www.hostname.com", port: 8888 })
      @handler.request = @handler.parser.run "GET http://www.hostname.com:8888/some_controller/some_action?param1=1&param2=2 HTTP/1.1"
    end

    describe "#prepare_response" do
      it "should call make_env" do
        @app.stub(:call).and_return([200, {}, []])
        @handler.prepare_response
        @handler.env.should_not be_nil
      end  

      it "should call the rack app" do
        @app.should_receive(:call)
        @handler.prepare_response
      end
    end

    describe "#make_env" do
      before(:each) do
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

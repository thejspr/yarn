require 'spec_helper'

module Yarn
  describe StaticHandler do

    before(:each) do
      @handler = StaticHandler.new @session
      @handler.stub(:extract_path).and_return("index.html")

      FakeFS.activate!
      @file_content = "<html><body>success!</body></html>"
      @file = File.open("index.html", 'w') do |file|
        file.write @file_content
      end
    end

    after(:each) do
      @handler.close_connection
      FakeFS.deactivate!
    end

    describe "#prepare_response" do
      it "should always fill the response body" do
        @handler.response[2].should be_empty
        @handler.prepare_response
        @handler.response[2].should_not be_empty
      end
    end

    describe "#read_file" do
      it "should return the contents of a file it it exists" do
        @handler.response[2].should be_empty
        @handler.read_file("index.html").should == [@file_content]
      end
    end
  end
end

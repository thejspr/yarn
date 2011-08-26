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

    describe "#get_mime_type" do
      it "should return false if the filetype cannot be detected" do
        @handler.get_mime_type("dumbfile.asdf").should be_false
      end

      it "should detect plain text files" do
        @handler.get_mime_type("file.txt").should == "text/plain"
      end

      it "should return false if the path doent have an extension" do
        @handler.get_mime_type("asdfasdf").should be_false
      end

      it "should detect css files" do
        @handler.get_mime_type("stylesheet.css").should == "text/css"
      end

      it "should detect javascript files" do
        @handler.get_mime_type("jquery.js").should == "text/javascript"
      end

      it "should detect html files" do
        @handler.get_mime_type("index.html").should == "text/html"
      end

      it "should detect image files" do
        ["png", "jpg", "jpeg", "gif", "tiff"].each do |filetype|
          @handler.get_mime_type("image.#{filetype}").should == "image/#{filetype}"
        end
      end

      it "should detect application formats" do
        formats = ["zip","pdf","postscript","x-tar","x-dvi"]
        formats.each do |filetype|
          @handler.get_mime_type("file.#{filetype}").should == "application/#{filetype}"
        end
      end
    end
  end
end

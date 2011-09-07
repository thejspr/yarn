require 'spec_helper'

module Yarn
  describe StaticHandler do

    before(:each) do
      @handler = StaticHandler.new
      @handler.session = @session

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
      it "should handle a directory" do
        File.delete("index.html")
        Dir.mkdir("testdir")
        @handler.stub(:extract_path).and_return("testdir")
        @handler.should_receive(:serve_directory).once
        @handler.prepare_response
      end

      it "returns a file if it exists" do
        @file = File.new("test.html", "w")
        @handler.stub(:extract_path).and_return("test.html")
        @handler.should_receive(:serve_file).once
        @handler.prepare_response
      end

      it "handles missing files" do
        @handler.stub(:extract_path).and_return("non-existing.html")
        @handler.should_receive(:serve_404_page).once
        @handler.prepare_response
      end
    end

    describe "#serve_file" do
      it "should read an existing file" do
        @handler.should_receive(:read_file).once
        @handler.serve_file("index.html")
      end
    end

    describe "#serve_directory" do
      it "should read index file if it exists" do
        Dir.mkdir("test")
        File.new("test/index.html", "w")
        @handler.should_receive(:read_file).once
        @handler.serve_directory("test")
      end

      it "should list a directory" do
        File.delete "index.html"
        DirectoryLister.should_receive(:list).once
        @handler.serve_directory(Dir.pwd)
      end
    end
    
    describe "#serve_404_page" do
      it "should read the error message" do
        @handler.should_receive(:error_message).once
        @handler.serve_404_page("non-existing-index.html")
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

    describe "#error_message" do
      it "should return an html formatted html string" do
        @handler.error_message.should =~ /<html>/
        @handler.error_message.should =~ /404/
      end
    end

    describe "#extract_path" do
      it "should remove any leading /'s" do
        @handler.request = { :uri => { :path => "/asdf" } }
        @handler.extract_path.should == "asdf"
      end

      it "should replace %20 with space" do
        @handler.request = { :uri => { :path => "asdf%20sdf%20" } }
        @handler.extract_path.should == "asdf sdf"
      end

      it "should return / if the path is /" do
        @handler.request = { :uri => { :path => "/" } }
        @handler.extract_path.should == "/"
      end
    end
  end
end

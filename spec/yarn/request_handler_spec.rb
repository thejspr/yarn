require 'spec_helper'

module Yarn
  describe RequestHandler do

    describe "Static requests" do

      before(:each) do
        @handler = RequestHandler.new
        @handler.session = @session

        @file_content = "<html><body>success!</body></html>"
        @file = File.open("index.html", 'w') do |file|
          file.write @file_content
        end
        Dir.mkdir("testdir") unless Dir.exists?("testdir")
      end

      after(:each) do
        File.delete("index.html") if File.exists?("index.html")
        File.delete("testdir/index.html") if File.exists?("testdir/index.html")
        Dir.delete("testdir") if Dir.exists?("testdir")
      end

      describe "#prepare_response" do
        it "should handle a directory" do
          File.delete("index.html")
          @handler.stub(:extract_path).and_return("testdir")
          @handler.should_receive(:serve_directory).once
          @handler.prepare_response
        end

        it "returns a file if it exists" do
          @file = File.new("test.html", "w")
          @handler.stub(:extract_path).and_return("test.html")
          @handler.should_receive(:serve_file).once
          @handler.prepare_response
          File.delete("test.html")
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
          File.new("testdir/index.html", "w")
          @handler.should_receive(:read_file).once
          @handler.serve_directory("testdir")
        end

        it "should list a directory" do
          File.delete "index.html"
          DirectoryLister.should_receive(:list).once
          @handler.serve_directory(Dir.pwd)
        end
      end

      describe "#read_file" do
        it "should return the contents of a file" do
          @handler.response.body.should be_empty
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

    describe "Dynamic requests" do
      before(:each) do
        @file_content = "!#/bin/ruby\nputs 'Success!'"
        @file = File.open("app.rb", 'w') do |file|
          file.write @file_content
        end
      end

      after(:each) do
        File.delete "app.rb" if File.exists? "app.rb"
      end

      describe "#prepare_response" do
        it "should execute the contents of a ruby file if it exists" do
          handler = RequestHandler.new
          handler.stub(:extract_path).and_return("app.rb")
          handler.prepare_response 
          handler.response.body.should include "Success!\n"
        end

        it "should should handle interpreter errors" do
          handler = RequestHandler.new
          File.open("app.rb", 'w') { |f| f.write "this resolves in an error" }
          handler.stub(:extract_path).and_return("app.rb")
          handler.prepare_response
          handler.response.status.should == 500
        end

      end
    end
  end
end

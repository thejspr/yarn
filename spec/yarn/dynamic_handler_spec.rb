require 'spec_helper'

module Yarn

  describe DynamicHandler do
    before(:each) do
      @file_content = "!#/bin/ruby\nputs 'Success!'"
      @file = File.open("app.rb", 'w') do |file|
        file.write @file_content
      end
    end

    after(:each) do
      File.delete "app.rb" if File.exists? "app.rb"
    end
    
    it "should inherit the requesthandler" do
      DynamicHandler.superclass.should == RequestHandler
    end

    describe "#prepare_response" do
      it "should execute the contents of a ruby file if it exists" do
        handler = DynamicHandler.new
        handler.stub(:extract_path).and_return("app.rb")
        handler.prepare_response 
        handler.response.body.should include "Success!\n"
      end

      it "should should handle interpreter errors" do
        handler = DynamicHandler.new
        File.open("app.rb", 'w') { |f| f.write "this resolves in an error" }
        handler.stub(:extract_path).and_return("app.rb")
        handler.prepare_response
        handler.response.status.should == 500
      end

    end
  end

end

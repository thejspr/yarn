require 'spec_helper'
require 'nokogiri'

module Yarn

  describe DirectoryLister do

    before(:each) do
      FakeFS.deactivate!
    end

    describe "#list" do
      it "returns valid HTML for a directory" do
        response = DirectoryLister.list("lib")
        response.should_not be_nil
        valid_html?(response).should be_true
      end

      it "returns valid HTML a long path" do
        FakeFS.deactivate!
        response = DirectoryLister.list("lib/yarn")
        response.should_not be_nil
        valid_html?(response).should be_true
      end
    end

    describe "#format_size" do
      it "should format bytes into B" do
        DirectoryLister.format_size(1.0).should == "1.00B"
      end
      it "should format bytes into KB" do
        DirectoryLister.format_size(1024.0).should == "1.00KB"
      end
      it "should format bytes into MB" do
        DirectoryLister.format_size(1024**2).should == "1.00MB"
      end
      it "should format bytes into GB" do
        DirectoryLister.format_size(1024**3).should == "1.00GB"
      end
      it "should format bytes into TB" do
        DirectoryLister.format_size(1024.0**4).should == "1.00TB"
      end
    end
  end

end

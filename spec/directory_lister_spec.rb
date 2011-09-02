require 'spec_helper'
require 'nokogiri'

module Yarn

  describe DirectoryLister do

    before(:each) do
      @lister = DirectoryLister.new
    end

    describe "#list" do
      it "returns valid HTML for a directory" do
        FakeFS.deactivate!
        response = @lister.list("lib")
        lambda { Nokogiri::HTML(response) { |config| config.strict }.should_not raise(Nokogiri::HTML::SyntaxError)
        }
        response.should_not be_nil
      end

      it "returns valid HTML a long path" do
        FakeFS.deactivate!
        response = @lister.list("lib/yarn")
        lambda { Nokogiri::HTML(response) { |config| config.strict }.should_not raise(Nokogiri::HTML::SyntaxError)
        }
        response.should_not be_nil
      end
    end

    describe "#format_size" do
      it "should format bytes into B" do
        @lister.format_size(1.0).should == "1.00B"
      end
      it "should format bytes into KB" do
        @lister.format_size(1024.0).should == "1.00KB"
      end
      it "should format bytes into MB" do
        @lister.format_size(1024**2).should == "1.00MB"
      end
      it "should format bytes into GB" do
        @lister.format_size(1024**3).should == "1.00GB"
      end
      it "should format bytes into TB" do
        @lister.format_size(1024.0**4).should == "1.00TB"
      end
    end
  end

end

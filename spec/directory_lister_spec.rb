require 'spec_helper'
require 'nokogiri'

module Yarn

  describe DirectoryLister do

    describe "#list" do
      it "returns valid HTML" do
        response = DirectoryLister.new("/var").list("/")
        lambda { Nokogiri::HTML(response) { |config| config.strict }.should_not raise(Nokogiri::HTML::SyntaxError)
        }
      end
    end
  end

end

require 'spec_helper'

module Yarn
  describe Parser do
    before do
    end 

    describe "#parse" do
      it "parse is available as a class method" do
        Parser.should respond_to(:parse)
      end

      it "returns a Request object" do
        Parser.stub(:parse).and_return(Request)
      end

    end

  end
end

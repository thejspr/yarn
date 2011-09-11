require 'spec_helper'

module Yarn
  describe ErrorPage do
    before(:each) do
      @handler = RequestHandler.new
    end

    describe "#serve_404_page" do
      it "should set the HTTP code" do
        @handler.serve_404_page
        @handler.response.status.should == 404
      end

      it "should set the body" do
        @handler.serve_404_page
        @handler.response.body.should_not be_empty
      end
    end

    describe "#serve_500_page" do
      it "should set the HTTP code" do
        @handler.serve_500_page
        @handler.response.status.should == 500
      end

      it "should set the body" do
        @handler.serve_500_page
        @handler.response.body.should_not be_empty
      end
    end
  end
end

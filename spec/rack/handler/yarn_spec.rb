require 'spec_helper'

module Rack
  module Handler

    include Helpers

    # describe Yarn do
    #   after do
    #     @thread.kill
    #   end

    #   it "should start the server" do
    #     @thread = Thread.new { Yarn.run("test_objects/config.ru") }
    #     response = get("/").body
    #     response.gsub(/\n?/,"").should == "Rack works"
    #   end
    # end
  end
end


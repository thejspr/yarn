require 'spec_helper'

module Yarn
  describe Worker do
    describe "#new" do
      it "should accept a handler and store it" do
        handler = RequestHandler.new
        worker = Worker.new handler
        
        worker.handler.should == handler
      end
    end

    describe "#process" do
      it "should execute the handler with the supplied session" do
        handler = RequestHandler.new
        handler.stub(:run).and_return(:response)
        worker = Worker.new handler
        
        worker.process("test").should == :response
      end
    end

  end

end

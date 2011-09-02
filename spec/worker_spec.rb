require 'spec_helper'

module Yarn

  describe Worker do
    describe "#new" do
      it "should accept a block and executes it" do
        @executed = false

        worker = Worker.new {
          @executed = true
        }
        
        @executed.should be_true
      end
    end

  end

end

require 'spec_helper'

module Yarn

  describe WorkerPool do

    describe "#new" do
      it "should accept a pool size and set it accordingly" do
        pool = WorkerPool.new 8 

        pool.size.should == 8
      end

      it "should instantiate the pool from the given size" do
        pool = WorkerPool.new 8

        pool.workers.size.should == 8
      end
    end

  end

end

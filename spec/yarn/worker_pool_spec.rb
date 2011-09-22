require 'spec_helper'

module Yarn

  describe WorkerPool do

    describe "#new" do
      it "should accept a pool size and set it accordingly" do
        pool = WorkerPool.new 2 
        pool.size.should == 2
      end

      it "should accept an optional rack app" do
        app = mock('app')
        pool = WorkerPool.new(2,app)
        pool.app.should == app
      end

      it "should set default size to 1024" do
        pool = WorkerPool.new
        pool.stub(:init_workers)
        pool.workers.size.should == 1024
      end

      it "should create a job queue" do
        pool = WorkerPool.new
        pool.jobs.class.should == Queue
      end

      it "should invoke the workers" do
        pool = WorkerPool.new 2
        pool.workers.size.should == 2
      end
    end

    describe "#determine_handler" do
      it "should return a RackHandler if an app is present" do
        app = mock('app')
        pool = WorkerPool.new(2,app)
        pool.determine_handler.class.should == RackHandler
      end
      
      it "should return a RequestHandler if an app is not present" do
        pool = WorkerPool.new(2)
        pool.determine_handler.class.should == RequestHandler
      end
    end

    describe "#init_workers" do
      it "should create an array of threads" do
        pool = WorkerPool.new 2
        pool.workers.each do |worker|
          worker.class.should == Thread
        end
      end

      it "should stop each worker after handler initialization" do
        pool = WorkerPool.new 2
        sleep 2
        pool.workers.each do |w|
          w.stop?.should be_true
        end
      end

      it "should set a RackHandler for each worker thread" do
        pool = WorkerPool.new 2
        sleep 1
        pool.workers.each do |w|
          w[:handler].class.should == RequestHandler
        end
      end

      it "should set a RequestHandler for each worker thread" do
        pool = WorkerPool.new(2,mock('app'))
        sleep 1
        pool.workers.each do |w|
          w[:handler].class.should == RackHandler
        end
      end
    end

    describe "#schedule" do
      it "should add a job to the jobs queue" do
        pool = WorkerPool.new 2
        pool.schedule("test_session")
        pool.jobs.pop.should == "test_session"
        pool.jobs.should be_empty
      end
    end

    describe "#listen!" do
      it "should start all worker threads" do
        pool = WorkerPool.new 2
        pool.listen!
        pool.workers.each do |w|
          w.alive?.should be_true
        end
      end
    end

  end

end

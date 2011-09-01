require 'spec_helper'

module Yarn
  describe TreetopParser do
    
    before(:each) do
      @parser = TreetopParser.new
    end

    describe "#run" do
     it "has the same interface as the ParsletParser" do
       @parser.should respond_to(:run)
     end
    end 

    describe "#parse request_line" do
      it "parses all request method types" do
        ['OPTIONS','GET','HEAD','POST','PUT','DELETE','TRACE','CONNECT'].each do |method|
          @parser.run(method + ' / HTTP/1.1').should_not be_nil
        end
      end

      it "parses no-resource URI" do
        @parser.run("GET * HTTP/1.1").should_not be_nil
        puts @parser.run("GET * HTTP/1.1").elements.first.text_value
      end

    #   it "parses the host" do
    #     result = @parser.run("GET http://www.test.com/index.html HTTP/1.1")
    #     result[:uri][:host].to_s.should == "www.test.com"
    #   end

    #   it "parses the path" do
    #     result = @parser.run("GET http://www.test.com/index.html HTTP/1.1")
    #     result[:uri][:path].to_s.should == "/index.html"
    #   end

    #   it "parses absolute URI" do
    #     result = @parser.run("GET http://187.123.231.12:8976/some/resource HTTP/1.1")
    #     result[:uri][:host].should == "187.123.231.12:8976"
    #     result[:uri][:path].should == "/some/resource"
    #   end

    #   it "parses absolute paths" do
    #     result = @parser.run("GET /another/resource HTTP/1.1")
    #     result[:uri][:path].should == "/another/resource"
    #   end

    #   it "parses HTTP version" do
    #     result = @parser.run("GET /another/resource HTTP/1.1")
    #     result[:version].to_s.should == "HTTP/1.1"
    #   end

    #   it "parses crlf" do
    #     lambda { @parser.run("GET / HTTP/1.1\r\n") }.should_not raise_error
    #     lambda { @parser.run("GET / HTTP/1.1") }.should_not raise_error
    #   end
    # end

    # describe "#parse headers" do
    #   it "accepts a request with no headers" do
    #     result = @parser.run("GET /another/resource HTTP/1.1\r\n")
    #     result[:headers].should be_empty
    #   end

    #   it "parses a Content-Length header" do
    #     request = "POST /resource/1/save HTTP/1.1\r\nContent-Length: 345\r\n"
    #     result = @parser.run(request)

    #     result[:headers]["Content-Length"].should == "345"
    #   end

    #   it "parses a Cookie header" do
    #     cookie = "Cookie: $Version=1; Skin=new;"
    #     request = "POST /form HTTP/1.1\r\n#{cookie}\r\n"
    #     result = @parser.run(request)
    #     result[:headers]["Cookie"].should == "$Version=1; Skin=new;"
    #   end

    #   it "parses multiple headers" do
    #     cookie = "Cookie: $Version=1; Skin=new;"
    #     user_agent_value = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
    #     user_agent = "User-Agent: #{user_agent_value}"
    #     request = "POST /form HTTP/1.1\r\n#{cookie}\r\n#{user_agent}"
    #     result = @parser.run(request)

    #     result[:headers].length.should == 2
    #     result[:headers]["User-Agent"].should == user_agent_value
    #   end

    #   it "parses an empty header" do
    #     lambda { @parser.run("GET / HTTP/1.1\r\nAccept: \r\n") }.should_not raise_error
    #     lambda { @parser.run("GET / HTTP/1.1\r\nAccept:") }.should_not raise_error
    #   end
    end
  end
end

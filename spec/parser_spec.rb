require 'spec_helper'

module Yarn
  describe Parser do
    before do
      @parser = Parser.new
    end 

    describe "#parse request_line" do
      it "parses all request method types" do
        ['OPTIONS','GET','HEAD','POST','PUT','DELETE','TRACE','CONNECT'].each do |method|
          @parser.parse(method + ' / HTTP/1.1')[:method].to_s.should == method
        end
      end

      it "parses no-resource URI" do
        @parser.parse("GET * HTTP/1.1")[:uri].to_s.should == "*"
      end

      it "parses the host" do
        result = @parser.parse("GET http://www.test.com/index.html HTTP/1.1")
        result[:uri][:host].to_s.should == "www.test.com"
      end

      it "parses the path" do
        result = @parser.parse("GET http://www.test.com/index.html HTTP/1.1")
        result[:uri][:path].to_s.should == "/index.html"
      end

      it "parses absolute URI" do
        result = @parser.parse("GET http://187.123.231.12:8976/some/resource HTTP/1.1")
        result[:uri][:host].should == "187.123.231.12:8976"
        result[:uri][:path].should == "/some/resource"
      end

      it "parses absolute paths" do
        result = @parser.parse("GET /another/resource HTTP/1.1")
        result[:uri][:path].should == "/another/resource"
      end

      it "parses HTTP version" do
        result = @parser.parse("GET /another/resource HTTP/1.1")
        result[:version].to_s.should == "HTTP/1.1"
      end

      it "parses crlf" do
        lambda { @parser.parse("GET / HTTP/1.1\r\n") }.should_not raise_error
        lambda { @parser.parse("GET / HTTP/1.1") }.should_not raise_error
      end
    end

    describe "#parse headers" do
      it "accepts a request with no headers" do
        result = @parser.parse("GET /another/resource HTTP/1.1\r\n")
        result[:headers].should be_empty
      end

      it "parses a Content-Length header" do
        request = "POST /resource/1/save HTTP/1.1\r\nContent-Length: 345\r\n"
        result = @parser.parse(request)
        result[:headers][0][:name].should == "Content-Length"
        result[:headers][0][:value].should == "345"
      end

      it "parses a Cookie header" do
        cookie = "Cookie: $Version=1; Skin=new;"
        request = "POST /form HTTP/1.1\r\n#{cookie}\r\n"
        result = @parser.parse(request)
        result[:headers][0][:name].should == "Cookie"
        result[:headers][0][:value].should == "$Version=1; Skin=new;"
      end

      it "parses multiple headers" do
        cookie = "Cookie: $Version=1; Skin=new;"
        user_agent = "User-Agent: Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
        request = "POST /form HTTP/1.1\r\n#{cookie}\r\n#{user_agent}"
        result = @parser.parse(request)
        result[:headers].length.should == 2
        result[:headers][1][:name].should == "User-Agent"
      end

      it "parses an empty header" do
        lambda { @parser.parse("GET / HTTP/1.1\r\nAccept: \r\n") }.should_not raise_error
        lambda { @parser.parse("GET / HTTP/1.1\r\nAccept:") }.should_not raise_error
      end
    end

  end
end

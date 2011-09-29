require 'spec_helper'

module Yarn
  describe ParsletParser do
    before do
      @parser = ParsletParser.new
    end 

    describe "#parse request_line" do
      it "parses all request method types" do
        ['OPTIONS','GET','HEAD','POST','PUT','DELETE','TRACE','CONNECT'].each do |method|
          @parser.run(method + ' / HTTP/1.1')[:method].to_s.should == method
        end
      end

      it "parses no-resource URI" do
        @parser.run("GET * HTTP/1.1")[:uri].to_s.should == "*"
      end

      it "parses the host" do
        result = @parser.run("GET http://www.test.com/index.html HTTP/1.1")
        result[:uri][:host].to_s.should == "www.test.com"
      end

      it "parses the path" do
        result = @parser.run("GET http://www.test.com/index.html HTTP/1.1")
        result[:uri][:path].to_s.should == "/index.html"
      end

      it "parses absolute URI" do
        result = @parser.run("GET http://187.123.231.12:8976/some/resource HTTP/1.1")
        result[:uri][:host].should == "187.123.231.12"
        result[:uri][:port].should == "8976"
        result[:uri][:path].should == "/some/resource"
      end

      it "parses absolute paths" do
        result = @parser.run("GET /another/resource HTTP/1.1")
        result[:uri][:path].should == "/another/resource"
      end

      it "parses HTTP version" do
        result = @parser.run("GET /another/resource HTTP/1.1")
        result[:version].to_s.should == "HTTP/1.1"
      end

      it "parses crlf" do
        lambda { @parser.run("GET / HTTP/1.1\r\n") }.should_not raise_error
        lambda { @parser.run("GET / HTTP/1.1") }.should_not raise_error
      end
    end

    describe "#parse parameters" do
      it "parses query in the url" do
        result = @parser.run("GET /page?param1=1&param2=2 HTTP/1.1\n")
        puts result
        result[:uri][:query].should == "param1=1&param2=2"
      end

      it "should parse query on rails assets" do
        result = @parser.run("GET assets/application.js?body=0 HTTP/1.1\n")
        puts result
        result[:uri][:query].should == "body=0"
        result[:uri][:path].should == "assets/application.js"
      end
    end

    describe "#parse headers" do
      it "accepts a request with no headers" do
        result = @parser.run("GET /another/resource HTTP/1.1\r\n")
        result[:headers].should be_empty
      end

      it "parses a Content-Length header" do
        request = "POST /resource/1/save HTTP/1.1\r\nContent-Length: 345\r\n"
        result = @parser.run(request)

        result[:headers]["Content-Length"].should == "345"
      end

      it "parses a Cookie header" do
        cookie = "Cookie: $Version=1; Skin=new;"
        request = "POST /form HTTP/1.1\r\n#{cookie}\r\n"
        result = @parser.run(request)
        result[:headers]["Cookie"].should == "$Version=1; Skin=new;"
      end

      it "parses multiple headers" do
        cookie = "Cookie: $Version=1; Skin=new;"
        user_agent_value = "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)"
        user_agent = "User-Agent: #{user_agent_value}"
        request = "POST /form HTTP/1.1\r\n#{cookie}\r\n#{user_agent}"
        result = @parser.run(request)

        result[:headers].length.should == 2
        result[:headers]["User-Agent"].should == user_agent_value
      end

      it "parses an empty header" do
        lambda { @parser.run("GET / HTTP/1.1\r\nAccept: \r\n") }.should_not raise_error
        lambda { @parser.run("GET / HTTP/1.1\r\nAccept:") }.should_not raise_error
      end
    end

    describe "#parse POST body" do
      it "should parse POST body" do
        header = "Cookie: $Version=1; Skin=new;"
        body = "attr=test"
        request = "POST /form HTTP/1.1\r\n#{header}\r\n\r\n#{body}"
        result = @parser.run(request)
        result[:body].should == body
      end

      it "should parse POST body with added line ending" do
        header = "Cookie: $Version=1; Skin=new;"
        body = "attr=test&attr2=some_other_value&attr3=1231682368125361823"
        request = "POST /form HTTP/1.1\r\n#{header}\r\n\r\n#{body}\r\n"
        result = @parser.run(request)
        result[:body].should == body
      end
    end

  end
end

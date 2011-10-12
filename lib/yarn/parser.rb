require 'rubygems'
require 'parslet'

module Yarn
  # LPEG style HTTP parser.
  class Parser < Parslet::Parser
    
    # general rules

    rule(:crlf) { str("\r\n") | str("\n") }

    rule(:space) { match('\s') }
    
    rule(:spaces) { match('\s+') }

    # header rules
    rule(:header_value) { match['^\r\n'].repeat(1) }

    rule(:header_name) { match['a-zA-Z\-'].repeat(1) }

    rule(:header) do 
      header_name.as(:name) >> 
      str(":") >> 
      space.maybe >> 
      header_value.as(:value).maybe >> 
      crlf.maybe 
    end

    # request-line rules
    rule(:http_version) { match['HTTP\/\d\.\d'].repeat(1) }

    rule(:query) do
      match['\S+'].repeat(1)
    end

    rule(:path) do 
      match['^\?'].repeat(1).as(:path) >> 
      str("?") >> 
      query.as(:query) | match['^\s'].repeat(1).as(:path)
    end

    rule(:port) { match['\d+'].repeat(1) }

    rule(:host) { match['^\/:'].repeat(1) }

    rule(:absolute_uri) do
      str("http://") >> 
      host.as(:host) >> 
      str(":").maybe >> 
      port.as(:port).maybe >>
      path
    end

    rule(:request_uri) { str('*') | absolute_uri | path }

    rule(:spaces) { match('\s+') }

    rule(:method) { match['OPTIONS|GET|HEAD|POST|PUT|DELETE|TRACE|CONNECT'].repeat(1) }

    # RFC2616: Method SP Request-URI SP HTTP-Version CRLF
    rule(:request_line) do 
      method.as(:method) >> 
      space >> 
      request_uri.as(:uri) >> 
      space >> 
      http_version.as(:version) >> 
      crlf.maybe 
    end
     
    # body rule
    rule(:body) { match['\S'].repeat(1) }

    # RFC2616: Request-Line *(( header ) CRLF) CRLF [ message-body ]
    rule(:request) do 
      request_line >> 
      header.repeat.as(:_process_headers).as(:headers) >> 
      crlf.maybe >>
      body.as(:body).maybe >>
      crlf.maybe
    end

    # starts parsing from the beginning using the :request rule
    root(:request)

    # Executes the parser on a given input string.
    def run(input)
      tree = parse input 
      HeadersTransformer.new.apply tree 
    end
  end

  # Formats the headers into a Hash with the header-name as the key.
  class HeadersTransformer < Parslet::Transform
    rule(:_process_headers => subtree(:headers)) do
      hash = {}
      headers.each { |h| hash[h[:name].to_s] = h[:value].to_s }
      hash
    end
  end
end

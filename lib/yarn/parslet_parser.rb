require 'rubygems'
require 'parslet'

module Yarn
  class ParsletParser < Parslet::Parser
    
    # general rules

    rule(:crlf) { str("\r\n") | str("\n") }

    rule(:space) { match('\s') }
    
    rule(:spaces) { match('\s+') }

    # header rules

    rule(:header_value) { match['[^\r\n]'].repeat(1) }

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

    rule(:absolute_path) { match['\S+'].repeat(1) }

    rule(:host) { match['[^\/]+'].repeat(1) }

    rule(:absolute_uri) do
      str("http://") >> 
      host.as(:host) >> 
      absolute_path.as(:path)
    end

    rule(:request_uri) { str('*') | absolute_uri | absolute_path.as(:path) }

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

    # RFC2616: Request-Line *(( header ) CRLF) CRLF [ message-body ]
    rule(:request) do 
      request_line >> 
      header.repeat.as(:_process_headers).as(:headers) >> 
      crlf.maybe
    end

    # starts parsing from the beginning using the :request rule
    root(:request)

    def run(input)
      tree = parse input 
      Transformer.new.apply tree 
    end
  end

  class Transformer < Parslet::Transform
    rule(:_process_headers => subtree(:headers)) do
      hash = {}
      headers.each { |h| hash[h[:name].to_s] = h[:value].to_s }
      hash
    end
  end
end
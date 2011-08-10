require 'rubygems'
require 'parslet'

module Yarn
  class Parser < Parslet::Parser
    
    # general rules

    rule(:crlf) { str("\r\n") }

    rule(:space) { match('\s') }
    
    rule(:spaces) { match('\s+') }

    # header rules

    rule(:header_value) { match['[^\r\n]'].repeat(1) }

    rule(:header_name) { match['a-zA-Z\-'].repeat(1) }

    rule(:header) { 
      header_name.as(:name) >> 
      str(":") >> 
      space.maybe >> 
      header_value.as(:value).maybe >> 
      crlf.maybe 
    }
    
    # request-line rules

    rule(:http_version) { match['HTTP\/\d\.\d'].repeat(1) }

    rule(:absolute_path) { match['\S+'].repeat(1) }

    rule(:host) { match['[^\/]+'].repeat(1) }

    rule(:absolute_uri) { str("http://") >> host.as(:host) >> absolute_path.as(:path) }

    rule(:request_uri) { str('*') | absolute_uri | absolute_path.as(:path) }

    rule(:spaces) { match('\s+') }

    rule(:method) { match['OPTIONS|GET|HEAD|POST|PUT|DELETE|TRACE|CONNECT'].repeat(1) }

    # RFC2616: Method SP Request-URI SP HTTP-Version CRLF
    rule(:request_line) { 
      method.as(:method) >> 
      space >> 
      request_uri.as(:uri) >> 
      space >> 
      http_version.as(:version) >> 
      crlf.maybe 
    }

    # RFC2616: Request-Line *(( header ) CRLF) CRLF [ message-body ]
    rule(:request) { 
      request_line >> 
      header.repeat.as(:headers) >> 
      crlf.maybe
    }

    # starts parsing from the beginning using the :request rule
    root(:request)
  end
end

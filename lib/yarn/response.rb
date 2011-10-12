module Yarn
  # Holds the response status, headers and body in an Array.
  class Response

    attr_accessor :content

    def initialize
      @content = [nil, {}, []]      
    end
  
    # HTTP status code set
    def status=(status)
      @content[0] = status
    end

    # HTTP status code get
    def status
      @content[0]
    end

    # Headers Hash set
    def headers=(headers)
      @content[1] = headers
    end

    # Headers Hash get
    def headers
      @content[1]
    end

    # Body Array set
    def body=(body)
      @content[2] = body
    end

    # Body Array get
    def body
      @content[2]
    end

    # Format to string
    def to_s
      @content
    end
  
  end
end


module Yarn
  class Response

    attr_accessor :content

    def initialize
      @content = [nil, {}, []]      
    end
  
    def status=(status)
      @content[0] = status
    end

    def status
      @content[0]
    end

    def headers=(headers)
      @content[1] = headers
    end

    def headers
      @content[1]
    end

    def body=(body)
      @content[2] = body
    end

    def body
      @content[2]
    end

    def to_s
      @content
    end
  
  end
end

require 'polyglot'
require 'treetop'
require 'yarn/http'

module Yarn
  class TreetopParser
    def run(request)
      parser = HTTPParser.new
      result = parser.parse(request)
      
      if !result
        puts parser.terminal_failures.join("\n")
        puts parser.failure_reason
        puts parser.failure_line
        puts parser.failure_column
      end

      result
    end
  end
end

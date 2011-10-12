require "yarn"
require "rack"
require "rack/handler"

module Rack
  module Handler
    # Yarn webserver
    class Yarn

      # Takes a Rackup file and an options Hash.
      def self.run(app, options={})
        options = options.merge({ rack: app })
        @server = ::Yarn::Server.new(options)
        @server.start
      end
    end
  end
end

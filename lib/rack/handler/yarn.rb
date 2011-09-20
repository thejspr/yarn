require "yarn"
require "rack"
require "rack/handler"

module Rack
  module Handler
    class Yarn
      def self.run(app, options={})
        server = ::Yarn::Server.new(app,options)
        server.start
      end

      def self.valid_options
        {
          "Host=HOST" => "Hostname to listen on (default: 127.0.0.1)",
          "Port=PORT" => "Port to listen on (default: 3000)",
        }
      end
    end
  end
end

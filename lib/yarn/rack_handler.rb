require 'rack'
require 'pry'

module Yarn
  class RackHandler < RequestHandler

    def initialize(app, opts)
      super(opts)
      @host,@port = opts[:host], opts[:port]
      @app = app
    end

    def prepare_response
      begin
        env = make_env
        @response.content = @app.call(env)
      rescue Exception => e
        log e.message
        log e.backtrace
      end
    end

    def make_env
      env = {
        "REQUEST_METHOD"    => @request[:method].to_s,
        "PATH_INFO"         => @request[:uri][:path].to_s,
        "QUERY_STRING"      => @request[:uri][:query].to_s,
        "SERVER_NAME"       => @host || @request[:uri][:host].to_s,
        "SERVER_PORT"       => @port || @request[:uri][:port].to_s,
        "SCRIPT_NAME"       => "",
        "rack.input"        => StringIO.new("").set_encoding(Encoding::ASCII_8BIT),
        "rack.version"      => Rack::VERSION,
        "rack.errors"       => $output,
        "rack.multithread"  => true,
        "rack.multiprocess" => false,
        "rack.run_once"     => false,
        "rack.url_scheme"   => "http"
      }
    end

  end
end

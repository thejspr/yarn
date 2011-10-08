require 'rack'

module Yarn
  class RackHandler < AbstractHandler

    attr_accessor :env

    def initialize(app)
      @parser = Parser.new
      @response = Response.new
      @app = app
    end

    def prepare_response
      begin
        make_env
        @response.content = @app.call(@env)
      rescue Exception => e
        log e.message
        log e.backtrace
      end
    end

    def make_env
      input = StringIO.new("").set_encoding(Encoding::ASCII_8BIT)
      input.string = @request[:body] if @request[:body]
      @env = {
        "REQUEST_METHOD"    => @request[:method].to_s,
        "PATH_INFO"         => @request[:uri][:path].to_s,
        "QUERY_STRING"      => @request[:uri][:query].to_s,
        "SERVER_NAME"       => @request[:uri][:host].to_s,
        "SERVER_PORT"       => @request[:uri][:port].to_s,
        "SCRIPT_NAME"       => "",
        "rack.input"        => input,
        "rack.version"      => Rack::VERSION,
        "rack.errors"       => $output,
        "rack.multithread"  => false,
        "rack.multiprocess" => true,
        "rack.run_once"     => false,
        "rack.url_scheme"   => "http"
      }
    end

  end
end

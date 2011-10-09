require 'rack'

module Yarn
  class RackHandler < AbstractHandler

    attr_accessor :env, :opts

    def initialize(app,opts={})
      @parser = Parser.new
      @response = Response.new
      @app = app
      @host = opts[:host]
      @port = opts[:port].to_s
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
      if has_body?
        input.string = @request[:body]
      end
      @env = {
        "REQUEST_METHOD"    => @request[:method].to_s,
        "PATH_INFO"         => @request[:uri][:path].to_s,
        "QUERY_STRING"      => @request[:uri][:query].to_s,
        "SERVER_NAME"       => @host,
        "SERVER_PORT"       => @port,
        "SCRIPT_NAME"       => "",
        "rack.input"        => input,
        "rack.version"      => Rack::VERSION,
        "rack.errors"       => $output,
        "rack.multithread"  => true,
        "rack.multiprocess" => true,
        "rack.run_once"     => false,
        "rack.url_scheme"   => "http"
      }
      @env["CONTENT_LENGTH"] = @request[:body].size.to_i if has_body?

      return @env
    end

    def has_body?
      value ||= !! @request[:body]
      value
    end

  end
end

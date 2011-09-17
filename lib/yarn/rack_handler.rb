require 'rack'

module Yarn
  class RackHandler < RequestHandler

    def prepare_response
      begin
        env = make_env
        app =  proc do |env|
          [200, { 'Content-Type' => 'text/html' }, ['rack works']]
        end
        @response.content = app.call(env)
        debug @response.to_s
      rescue Exception => e
        debug e.message
      end
    end

    def make_env
      env = {}
      env[:REQUEST_METHOD] = @request[:method].to_s
      env[:SCRIPT_NAME] = ""
      env[:PATH_INFO] = @request[:uri][:path].to_s
      env[:QUERY_STRING] = @request[:uri][:query].to_s
      env[:SERVER_NAME] = @request[:uri][:host]
      env[:SERVER_PORT] = @request[:uri][:port]
      env
    end

  end
end

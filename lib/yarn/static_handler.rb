require 'yarn/request_handler'

module Yarn

  class StaticHandler < RequestHandler

    def prepare_response
      path = extract_path

      if File.exists? path
        @response[0] = 200
        @response[2] = read_file path
      elsif File.directory? path
        @response[0] = 200
        @response[2] << directory_listing
      else
        @response[0] = 404
        @response[2] << error_message
      end
    end

    def read_file(path)
      file_contents = []

      file = File.new(path, "r")

      while (line = file.gets) do
        file_contents << line
      end

      file.close
      file_contents
    end

    def extract_path
      path = @request[:uri][:path].to_s
      path = path[1..-1] if path[0] == "/"
    end

    def directory_listing
    end

    def error_message
      "<html><head><title>404</title></head><body><h1>File does not exist.</h1></body><html>"
    end
  end
end

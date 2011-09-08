require 'yarn/request_handler'
require 'yarn/directory_lister'

module Yarn

  class StaticHandler < RequestHandler

    def prepare_response
      path = extract_path

      if File.directory? path
        serve_directory path
      elsif File.exists?(path)
        serve_file path
      else
        serve_404_page path
      end
    end

    def serve_file(path)
      @response[0] = 200
      @response[2] << read_file(path)
      @response[1]["Content-Type"] = get_mime_type path
    end

    def read_file(path)
      file_contents = []

      File.open(path, "r") do |file|
        while (line = file.gets) do
          file_contents << line
        end
      end

      file_contents
    end

    def extract_path
      path = @request[:uri][:path].to_s
      if path[0] == "/" && path != "/"
        path = path[1..-1] 
      end
      path.gsub(/%20/, " ").strip
    end

    def error_message
      "<html><head><title>404</title></head><body><h1>File does not exist.</h1></body><html>"
    end

    def get_mime_type(path)
      return false unless path.include? '.'
      filetype = path.split('.').last

      return case
        when ["html", "htm"].include?(filetype)
          "text/html"
        when "txt" == filetype 
          "text/plain"
        when "css" == filetype
          "text/css"
        when "js" == filetype
          "text/javascript"
        when ["png", "jpg", "jpeg", "gif", "tiff"].include?(filetype)
          "image/#{filetype}"
        when ["zip","pdf","postscript","x-tar","x-dvi"].include?(filetype)
          "application/#{filetype}"
        else false
      end
    end

  end
end

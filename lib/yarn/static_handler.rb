require 'yarn/request_handler'

module Yarn

  class StaticHandler < RequestHandler

    def prepare_response
      path = extract_path

      if File.exists? path
        @response[0] = 200
        @response[2] = read_file path
        if (mime_type = get_mime_type path)
          @response[1]["Content-Type"] = mime_type
          debug "Static request: 200 #{path} #{mime_type}"
        else
          debug "Static request: 200 #{path} Mime-type not detected!"
        end
      elsif File.directory? path
        @response[0] = 200
        @response[2] << directory_listing
        debug "Static request: 200 #{path} (directory)"
      else
        @response[0] = 404
        @response[2] << error_message
        debug "Static request: 404 #{path} (file/folder not found)"
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

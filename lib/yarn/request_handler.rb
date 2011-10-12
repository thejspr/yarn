module Yarn
  # handler for static and dynamic requests
  class RequestHandler < AbstractHandler
    
    # Determines whether to serve a directory listing, the contetents of a file,
    # or an error page.
    def prepare_response
      path = extract_path

      @response.headers["Content-Type"] = "text/html"

      begin
        if File.directory?(path)
          serve_directory(path)
        elsif File.exists?(path)
          path =~ /.*\.rb$/ ? serve_ruby_file(path) : serve_file(path)
        else
          serve_404_page
        end
      rescue ProcessingError
        log "An error occured processing #{path}"
        serve_500_page
      end
    end

    # Sets the response for a static file.
    def serve_file(path)
      @response.body << read_file(path)
      @response.headers["Content-Type"] = get_mime_type path
      @response.status = 200
    end

    # Sets the response for a dynamic file.
    def serve_ruby_file(path)
      @response.body << execute_script(path)
      @response.status = 200
    end

    # Sets the reponse for a directory listing.
    def serve_directory(path)
      @response.status = 200
      if File.exists?("index.html") || File.exists?("/index.html")
        @response.body = read_file "index.html"
        @response.headers["Content-Type"] = "text/html"
      else
        @response.headers["Content-Type"] = "text/html"
        @response.body << DirectoryLister.list(path)
      end
    end

    # Reads the contents of a file into an Array.
    def read_file(path)
      file_contents = []
      File.open(path).each { |line| file_contents << line }

      file_contents
    end

    # Evaluates the contents of a ruby file and returns the output.
    def execute_script(path)
      response = `ruby #{path} #{post_body}`
      if !! ($?.to_s =~ /1$/)
        raise ProcessingError
      else
        response
      end
    end

    # Determines the MIME type based on the file extension.
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

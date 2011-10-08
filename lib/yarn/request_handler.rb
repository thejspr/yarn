module Yarn
  class RequestHandler < AbstractHandler
    def prepare_response
      path = extract_path

      @response.headers["Content-Type"] = "text/html"

      begin
        if File.directory? path
          serve_directory path
        elsif File.exists?(path)
          if path =~ /.*\.rb$/
            @response.body << execute_script(path)
            @response.status = 200
          else
            serve_file(path)
          end
        else
          serve_404_page
        end
      rescue ProcessingError
        log "An error occured processing #{path}"
        serve_500_page
      end
    end

    def serve_file(path)
      @response.status = 200
      @response.body << read_file(path)
      @response.headers["Content-Type"] = get_mime_type path
    end

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

    def read_file(path)
      file_contents = []
      File.open(path).each { |line| file_contents << line }

      file_contents
    end

    def execute_script(path)
      response = `ruby #{path} #{post_body}`
      if !! ($?.to_s =~ /1$/)
        raise ProcessingError
      else
        response
      end
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
